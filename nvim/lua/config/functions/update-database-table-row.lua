local filter_database_table = require("config.functions.filter-database-table")
local find_index = require("lib.tables.find-index")
local interpolate = require("lib.strings.interpolate")
local parse_row = require("lib.databases.parse-row")
local split = require("lib.strings.split")

return function()
  filter_database_table(function(table_name, data)
    local headers = parse_row(data[1])
    local values = parse_row(data[3])
    local id = values[find_index(headers, "'id'")]
    local updates = {}

    for i, v in ipairs(headers) do
      if v ~= "id" then
        local update = interpolate("{header} = {value}", { header = v:gsub("'", '"'), value = values[i] })
        table.insert(updates, update)
      end
    end

    local template = [[UPDATE "{table}" SET {updates} WHERE id = {id};]]

    local sql = interpolate(template, {
      id = id,
      table = table_name,
      updates = table.concat(updates, ", "),
    })

    vim.api.nvim_buf_set_lines(0, 0, -1, false, split(sql, "\n"))
  end)
end
