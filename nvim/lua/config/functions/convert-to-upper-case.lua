local to_upper_case = require("lib.strings.to-upper-case")

return function() vim.cmd("normal ciw" .. to_upper_case(vim.fn.expand("<cword>"))) end
