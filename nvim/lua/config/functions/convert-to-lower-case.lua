local to_lower_case = require("lib.strings.to-lower-case")

return function() vim.cmd("normal ciw" .. to_lower_case(vim.fn.expand("<cword>"))) end
