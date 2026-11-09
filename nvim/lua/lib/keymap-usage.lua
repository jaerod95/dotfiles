-- Tracks how often each custom keymap (anything bound through config.functions.bind-key) is used.
--
-- A key press only bumps a counter in a Lua table. Every minute (and on exit) the pending counts
-- are merged into a JSON file using libuv's async fs calls, which run on libuv's thread pool,
-- so key presses never wait on disk. Merging into whatever is on disk means several open
-- nvim instances all add to the same totals. Keymaps that have never been used show up with
-- count 0, which makes it easy to spot ones to relearn or remove.
--
-- View the totals with :KeymapUsage
local uv = vim.uv
local M = {}

M.path = vim.fn.stdpath("data") .. "/keymap-usage.json"

local FLUSH_INTERVAL_MS = 60 * 1000

local known = {} -- id -> desc for every keymap registered this session
local pending = {} -- id -> { count, last_used } since the last flush
local inflight = nil -- batch currently being written by an async flush
local has_new_keymaps = false
local flushing = false
local superseded = false -- set when a sync flush already wrote the in-flight batch

local function today() return os.date("%Y-%m-%d") end

function M.register(mode, lhs, desc)
  local id = (type(mode) == "table" and table.concat(mode, ",") or mode) .. " " .. lhs
  if known[id] == nil then has_new_keymaps = true end
  known[id] = desc or ""
  return id
end

function M.record(id)
  local entry = pending[id]
  if entry then
    entry.count = entry.count + 1
  else
    pending[id] = { count = 1, last_used = today() }
  end
end

-- Merges known keymaps and one or more batches of counts into the existing file contents.
local function merge(text, batches)
  local ok, data = pcall(vim.json.decode, text or "")
  if not ok or type(data) ~= "table" then data = {} end

  for id, desc in pairs(known) do
    local entry = type(data[id]) == "table" and data[id] or { count = 0 }
    entry.desc = desc
    data[id] = entry
  end

  for _, batch in ipairs(batches) do
    for id, use in pairs(batch) do
      local entry = data[id] or { count = 0, desc = known[id] or "" }
      entry.count = (entry.count or 0) + use.count
      entry.last_used = use.last_used
      data[id] = entry
    end
  end

  return data
end

-- One entry per line, most used first, so the file is easy to skim.
local function encode(data)
  local ids = vim.tbl_keys(data)
  table.sort(ids, function(a, b)
    local ca, cb = data[a].count or 0, data[b].count or 0
    if ca ~= cb then return ca > cb end
    return a < b
  end)

  local lines = {}
  for _, id in ipairs(ids) do
    local e = data[id]
    table.insert(
      lines,
      string.format(
        '  %s: {"count": %d, "last_used": %s, "desc": %s}',
        vim.json.encode(id),
        e.count or 0,
        vim.json.encode(e.last_used or vim.NIL),
        vim.json.encode(e.desc or "")
      )
    )
  end
  return "{\n" .. table.concat(lines, ",\n") .. "\n}\n"
end

local function nothing_to_write() return next(pending) == nil and not has_new_keymaps end

-- Write to a temp file and rename it over the real one, so a reader never sees a half-written file.
local function tmp_path(kind) return M.path .. "." .. kind .. "." .. uv.os_getpid() end

local function read_async(cb)
  uv.fs_open(M.path, "r", 438, function(open_err, fd)
    if open_err then return cb(nil) end
    uv.fs_fstat(fd, function(_, stat)
      uv.fs_read(fd, stat and stat.size or 0, 0, function(_, text)
        uv.fs_close(fd, function() cb(text) end)
      end)
    end)
  end)
end

local function write_async(text, cb)
  local tmp = tmp_path("async")
  uv.fs_open(tmp, "w", 420, function(open_err, fd)
    if open_err then return cb(open_err) end
    uv.fs_write(fd, text, -1, function(write_err)
      uv.fs_close(fd, function()
        if write_err then return cb(write_err) end
        -- a sync flush ran meanwhile and already wrote this batch; don't clobber its newer file
        if superseded then return uv.fs_unlink(tmp, function() cb(nil) end) end
        uv.fs_rename(tmp, M.path, cb)
      end)
    end)
  end)
end

function M.flush_async()
  if flushing or nothing_to_write() then return end
  flushing = true
  superseded = false
  inflight, pending, has_new_keymaps = pending, {}, false

  read_async(function(text)
    write_async(encode(merge(text, { inflight })), function(err)
      if err and not superseded then
        -- put the batch back so it is retried on the next flush
        for id, use in pairs(inflight) do
          local entry = pending[id]
          if entry then
            entry.count = entry.count + use.count
          else
            pending[id] = use
          end
        end
        has_new_keymaps = true
      end
      inflight = nil
      flushing = false
    end)
  end)
end

-- Synchronous flush used on exit (and before viewing), so nothing is lost when nvim quits.
function M.flush_sync()
  if nothing_to_write() and not inflight then return end

  local text = nil
  local fd = uv.fs_open(M.path, "r", 438)
  if fd then
    local stat = uv.fs_fstat(fd)
    text = uv.fs_read(fd, stat and stat.size or 0, 0)
    uv.fs_close(fd)
  end

  local batches = { pending }
  if inflight then table.insert(batches, inflight) end

  local tmp = tmp_path("sync")
  local out = uv.fs_open(tmp, "w", 420)
  if not out then return end
  uv.fs_write(out, encode(merge(text, batches)), -1)
  uv.fs_close(out)
  if uv.fs_rename(tmp, M.path) then
    if inflight then superseded = true end
    pending, inflight, has_new_keymaps = {}, nil, false
  end
end

local timer = uv.new_timer()
timer:start(FLUSH_INTERVAL_MS, FLUSH_INTERVAL_MS, function() M.flush_async() end)
-- don't let the timer keep nvim alive
timer:unref()

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("KeymapUsage", { clear = true }),
  callback = function() M.flush_sync() end,
})

vim.api.nvim_create_user_command("KeymapUsage", function()
  M.flush_sync()
  vim.cmd.edit(vim.fn.fnameescape(M.path))
end, { desc = "Open keymap usage totals" })

return M
