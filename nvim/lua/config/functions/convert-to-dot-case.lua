local to_dot_case = require("lib.strings.to-dot-case")

return function() vim.cmd("normal ciw" .. to_dot_case(vim.fn.expand("<cword>"))) end
