local filter_database_table = require("config.functions.filter-database-table")
local find_index = require("lib.tables.find-index")
local interpolate = require("lib.strings.interpolate")
local parse_row = require("lib.databases.parse-row")
local split = require("lib.strings.split")

return function()
  filter_database_table(function(table_name, data)
    local headers = parse_row(data[1])
    local values = parse_row(data[3])

    local id_index = find_index(headers, "'id'")
    table.remove(headers, id_index)
    table.remove(values, id_index)

    local template = [[INSERT INTO "{table}" ({headers}) VALUES ({values});]]
    local sql = interpolate(template, {
      table = table_name,
      headers = table.concat(headers, ", "):gsub("'", '"'),
      values = table.concat(values, ", "),
    }):gsub([[""]], "NULL")

    vim.api.nvim_buf_set_lines(0, 0, -1, false, split(sql, "\n"))
  end)
end
