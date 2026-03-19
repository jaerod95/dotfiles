return function(str, sep)
  local accumulator = {}

  for substr in string.gmatch(str, "([^" .. (sep or "%s") .. "]+)") do
    table.insert(accumulator, substr)
  end

  return accumulator
end
