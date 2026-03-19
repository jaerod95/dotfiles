return function(sequence, fn, initial)
  local accumulator = initial

  for index, value in ipairs(sequence) do
    accumulator = fn(accumulator, value, index)
  end

  return accumulator
end
