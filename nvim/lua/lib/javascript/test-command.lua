-- Builds the shell command that runs a JS/TS test file with the project's own runner, from the
-- package that owns the file (monorepos keep a jest/vitest config per package).
-- Override per project in .neovim.json, where %s is the test file path relative to its package:
-- { "debug_test": { "command": "pnpm exec jest --runInBand %s" } }
local get = require("lib.tables.get")

local read = function(path)
  local file = io.open(path, "r")
  if not file then return "" end
  local content = file:read("*all")
  file:close()
  return content
end

local package_manager_exec = function(file)
  if vim.fs.root(file, "pnpm-lock.yaml") then return "pnpm exec" end
  if vim.fs.root(file, "yarn.lock") then return "yarn" end
  if vim.fs.root(file, { "bun.lock", "bun.lockb" }) then return "bunx" end
  return "npx"
end

local test_runner = function(package_root, file)
  local workspace_root = vim.fs.root(file, { "pnpm-lock.yaml", "yarn.lock", "package-lock.json", ".git" })
  local manifests = read(package_root .. "/package.json")
  if workspace_root then manifests = manifests .. read(workspace_root .. "/package.json") end
  if manifests:find('"vitest"') then return "vitest run" end
  return "jest"
end

-- jest and vitest both treat -t as a regex over the full test name
local escape_regex = function(s) return (s:gsub("[%^%$%(%)%.%[%]%*%+%-%?{}|\\]", "\\%0")) end

return function(file, test_name)
  local package_root = vim.fs.root(file, "package.json") or vim.fn.getcwd()
  local relative_file = file:sub(#package_root + 2)

  local override = get(project_config, { "debug_test", "command" })
  local command = override and string.format(override, vim.fn.shellescape(relative_file))
    or string.format(
      "%s %s %s",
      package_manager_exec(file),
      test_runner(package_root, file),
      vim.fn.shellescape(relative_file)
    )
  if test_name then command = command .. " -t " .. vim.fn.shellescape(escape_regex(test_name)) end

  return "cd " .. vim.fn.shellescape(package_root) .. " && " .. command
end
