return function(sequence, value)
  for i, v in ipairs(sequence) do
    if v == value then return i end
  end

  return nil
end
