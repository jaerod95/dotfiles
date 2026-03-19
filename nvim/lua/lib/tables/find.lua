return function(sequence, fn)
  for index, value in ipairs(sequence) do
    if fn(value, index) then return value end
  end

  return nil
end
