return function(mode, keys, func, desc, opts)
  opts = opts or {}
  opts = {
    buffer = opts.buffer,
    desc = desc,
    expr = opts.expr or false,
    remap = opts.remap or false,
    silent = opts.silent == nil and true or opts.silent,
  }

  vim.keymap.set(mode, keys, func, opts)
end
