local entries = require("lib.tables.entries")
local get = require("lib.tables.get")
local reduce = require("lib.tables.reduce")
local to_kebab_case = require("lib.strings.to-kebab-case")

local escape_pattern = function(s)
  return (s:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

local escape_replacement = function(s)
  return (s:gsub("%%", "%%%%"))
end

local unalias = function(file_path)
  local cwd = vim.fn["getcwd"]()
  local aliases = get(jsconfig, { "compilerOptions", "paths" }, {})

  -- Pick the single most-specific matching alias instead of chaining a gsub
  -- for every alias. Wildcard aliases (e.g. "#integrations/*") match by
  -- prefix; exact aliases (e.g. "#" or "#core") match only when the import
  -- equals the alias exactly. Applying a bare "#" -> "./src" alias as a prefix
  -- would corrupt "#integrations/..." into "./srcintegrations/...".
  local best = reduce(entries(aliases), function(acc, pathAlias)
    local alias, paths = unpack(pathAlias)
    if type(paths) ~= "table" or paths[1] == nil then return acc end

    local is_wildcard = alias:sub(-1) == "*"
    local alias_prefix = (alias:gsub("%*$", ""))
    local path_prefix = (paths[1]:gsub("%*$", ""))

    local matches = is_wildcard and file_path:sub(1, #alias_prefix) == alias_prefix
      or file_path == alias_prefix

    if matches and (acc == nil or #alias_prefix > #acc.alias_prefix) then
      return { alias_prefix = alias_prefix, path_prefix = path_prefix }
    end
    return acc
  end, nil)

  if best == nil then return file_path end

  local pattern = "^" .. escape_pattern(best.alias_prefix)
  local replacement = escape_replacement(cwd .. "/" .. best.path_prefix)
  return (file_path:gsub(pattern, replacement))
end

return function()
  local current_file_path = vim.fn.expand("%:h")
  local function_name = vim.fn.expand("<cword>")
  local move_cmd = string.format('mrgg^/%s<CR>/from<CR>f"<ESC>l', function_name)
  vim.api.nvim_input(move_cmd)
  vim.schedule(function()
    local import_line = vim.api.nvim_get_current_line()
    vim.api.nvim_input("`r")
    vim.schedule(function()
      local raw_import = string.match(import_line, '"(.-)"')
      local import = unalias(raw_import):gsub("index.js", "")
      local prefix = string.sub(import, 1, 1)
      local import_path = prefix == "/" and import or current_file_path .. "/" .. import
      local is_absolute_path = string.match(import, "%.js$")
      local import_is_directory = vim.fn.isdirectory(import_path)

      if is_absolute_path or import_is_directory ~= 1 then
        vim.cmd("edit " .. import_path)
      else
        local function_folder_path = import_path .. "/" .. function_name
        local function_folder_exists = vim.fn.isdirectory(function_folder_path)
        local kebab_function_folder = to_kebab_case(function_name)
        local kebab_function_folder_path = import_path .. "/" .. kebab_function_folder
        local kebab_function_folder_exists = vim.fn.isdirectory(kebab_function_folder_path)

        if function_folder_exists == 1 then
          vim.cmd("edit " .. function_folder_path .. "/index.js")
        elseif kebab_function_folder_exists == 1 then
          vim.cmd("edit " .. kebab_function_folder_path .. "/index.js")
        else
          vim.cmd("edit " .. import_path .. "/index.js")
        end
      end
    end)
  end)
end
