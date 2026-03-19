local to_camel_case = require("lib.strings.to-camel-case")
local to_kebab_case = require("lib.strings.to-kebab-case")
local to_lower_case = require("lib.strings.to-lower-case")
local to_pascal_case = require("lib.strings.to-pascal-case")
local to_snake_case = require("lib.strings.to-snake-case")
local to_upper_case = require("lib.strings.to-upper-case")

return function()
  local word = vim.fn.expand("<cword>")
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  if replacement == "" then return end

  local conversions = {
    { to_camel_case(word), to_camel_case(replacement) },
    { to_kebab_case(word), to_kebab_case(replacement) },
    { to_lower_case(to_snake_case(word)), to_lower_case(to_snake_case(replacement)) },
    { to_pascal_case(word), to_pascal_case(replacement) },
    { to_snake_case(word), to_snake_case(replacement) },
    { to_upper_case(to_snake_case(word)), to_upper_case(to_snake_case(replacement)) },
  }

  for _, pair in ipairs(conversions) do
    local cmd = string.format("%%s/\\<%s\\>/%s/gI", pair[1], pair[2])
    vim.cmd("silent! " .. cmd)
  end
end
