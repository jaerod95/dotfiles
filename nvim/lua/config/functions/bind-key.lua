local usage = require("lib.keymap-usage")

return function(mode, keys, func, desc, opts)
  opts = opts or {}
  opts = {
    buffer = opts.buffer,
    desc = desc,
    expr = opts.expr or false,
    remap = opts.remap or false,
    silent = opts.silent == nil and true or opts.silent,
  }

  -- wrap the mapping so each use is counted (see lib/keymap-usage.lua, view with :KeymapUsage)
  local id = usage.register(mode, keys, desc)
  local rhs = func
  if type(func) == "function" then
    rhs = function(...)
      usage.record(id)
      return func(...)
    end
  elseif not opts.expr then
    -- string rhs: an expr mapping that returns the same keys behaves identically
    -- (remap, <CR>, partial ":Cmd " prompts, inserted text) but lets us count the press
    rhs = function()
      usage.record(id)
      return func
    end
    opts.expr = true
  end

  vim.keymap.set(mode, keys, rhs, opts)
end
