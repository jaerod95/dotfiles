return function(object)
  local entries = {}
  for key, value in pairs(object) do
    table.insert(entries, { key, value }) -- each entry is a table with key and value
  end
  return entries
end
