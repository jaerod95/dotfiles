-- Maps between a source file and its colocated test (foo.service.ts <-> foo.service.spec.ts).
-- The suffix defaults to ".spec" and can be changed per project in .neovim.json:
-- { "open_test": { "suffix": ".test" } }
local get = require("lib.tables.get")

local extension_pattern = "(%.[mc]?[jt]sx?)$"
local suffixes = { ".spec", ".test" }

local exists = function(path) return vim.uv.fs_stat(path) ~= nil end

local preferred_suffix = function() return get(project_config, { "open_test", "suffix" }, ".spec") end

local M = {}

-- Returns the path without its test suffix, or nil when the path isn't a test file.
M.source_for = function(path)
  for _, suffix in ipairs(suffixes) do
    local base, extension = path:match("^(.*)" .. vim.pesc(suffix) .. extension_pattern)
    if base then return base .. extension end
  end
  return nil
end

M.is_test = function(path) return M.source_for(path) ~= nil end

-- Returns the existing test for a source file, or where the preferred one would go.
M.test_for = function(path)
  local base, extension = path:match("^(.*)" .. extension_pattern)
  if not base then return nil end

  local preferred = base .. preferred_suffix() .. extension
  if exists(preferred) then return preferred end
  for _, suffix in ipairs(suffixes) do
    local candidate = base .. suffix .. extension
    if exists(candidate) then return candidate end
  end
  return preferred
end

return M
