return function(sequence, fn)
  local accumulator = {}

  for index, value in ipairs(sequence) do
    if fn(value, index) then table.insert(accumulator, value) end
  end

  return accumulator
end
