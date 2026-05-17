local json = require("lib.json")

local read_json = function(path)
  local file = io.open(path, "r")
  if not file then return nil end
  local content = file:read("*all")
  file:close()
  local success, config = pcall(json.parse, content)
  if not success then return nil end
  return config
end

local load_jsconfig = function()
  local cwd = vim.fn["getcwd"]()

  local config = read_json(cwd .. "/jsconfig.json")
    or read_json(cwd .. "/tsconfig.json")
    or { compilerOptions = { paths = {} } }

  config.compilerOptions = config.compilerOptions or {}
  config.compilerOptions.paths = config.compilerOptions.paths or {}

  local pkg = read_json(cwd .. "/package.json")
  if pkg and type(pkg.imports) == "table" then
    for alias, target in pairs(pkg.imports) do
      if config.compilerOptions.paths[alias] == nil then
        if type(target) == "string" then
          config.compilerOptions.paths[alias] = { target }
        elseif type(target) == "table" and type(target.default) == "string" then
          config.compilerOptions.paths[alias] = { target.default }
        end
      end
    end
  end

  return config
end

jsconfig = load_jsconfig()
