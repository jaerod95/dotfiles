local interpolate = require("lib.strings.interpolate")
local map = require("lib.tables.map")
local split = require("lib.strings.split")
local trim = require("lib.strings.trim")

return function(row)
  return map(split(row, "|"), function(value)
    local trimmed_value = trim(value)

    if trimmed_value == "" then
      return "NULL"
    elseif trimmed_value == "t" then
      return "TRUE"
    elseif trimmed_value == "f" then
      return "FALSE"
    elseif string.match(trimmed_value, "^%d+$") then
      return trimmed_value
    else
      return interpolate([['{str}']], { str = trimmed_value })
    end
  end)
end
