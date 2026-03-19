return function(fn, ...)
  local bound = { ... }
  return function(...)
    local args = { unpack(bound) }
    for _, v in ipairs({ ... }) do
      table.insert(args, v)
    end
    return fn(unpack(args))
  end
end
