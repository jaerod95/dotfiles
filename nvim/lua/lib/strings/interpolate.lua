return function(str, values)
  return str:gsub("{(.-)}", function(key)
    local original_value = "{" .. key .. "}"
    return tostring(values[key] or original_value)
  end)
end
