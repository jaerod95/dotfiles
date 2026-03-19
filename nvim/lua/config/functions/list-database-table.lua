local actions = require("telescope.actions")
local config = require("telescope.config")
local execute_database_query = require("config.functions.execute-database-query")
local finders = require("telescope.finders")
local interpolate = require("lib.strings.interpolate")
local list_table = require("lib.databases.postgres.list-table")
local list_tables = require("lib.databases.postgres.list-tables")
local map = require("lib.tables.map")
local pickers = require("telescope.pickers")
local split = require("lib.strings.split")
local state = require("telescope.actions.state")

local get_tables = function()
  return map(execute_database_query(list_tables), function(tableName) return tableName:gsub("%s+", "") end)
end

return function()
  pickers
    .new({}, {
      finder = finders.new_table({ results = get_tables() }),
      sorter = config.values.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = state.get_selected_entry()
          if selection and selection[1] then
            local qualified_name = selection[1]
            local database_name = split(qualified_name, "%.")[1]
            local table_name = split(qualified_name, "%.")[2]
            local sql = interpolate(list_table, { dbname = database_name, table = table_name })
            vim.api.nvim_buf_set_lines(0, 0, -1, false, split(sql, "\n"))
            vim.cmd("w")
          end
        end)
        return true
      end,
    })
    :find()
end
