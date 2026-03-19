local entries = require("lib.tables.entries")
local get = require("lib.tables.get")
local reduce = require("lib.tables.reduce")
local to_kebab_case = require("lib.strings.to-kebab-case")

local unalias = function(file_path)
  local cwd = vim.fn["getcwd"]()
  local aliases = get(jsconfig, { "compilerOptions", "paths" }, {})
  return reduce(entries(aliases), function(acc, pathAlias)
    local alias, paths = unpack(pathAlias)
    local path = string.gsub(paths[1], "*", "")
    return string.gsub(acc, alias, cwd .. "/" .. path)
  end, file_path)
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
      local import = string.match(unalias(import_line), '"(.-)"'):gsub("index.js", "")
      local prefix = string.sub(import, 1, 1)
      local import_path = prefix == "/" and import or current_file_path .. "/" .. import
      local is_absolute_path = string.match(import, "%.js$")
      local is_directory = vim.fn.isdirectory(import_path)

      if is_absolute_path or is_directory ~= 1 then
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
