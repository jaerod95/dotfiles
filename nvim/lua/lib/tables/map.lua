return function(sequence, fn)
  local accumulator = {}

  for index, value in ipairs(sequence) do
    local new_value = fn(value, index)
    table.insert(accumulator, new_value)
  end

  return accumulator
end
