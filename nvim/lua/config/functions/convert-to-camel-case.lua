local to_camel_case = require("lib.strings.to-camel-case")

return function() vim.cmd("normal ciw" .. to_camel_case(vim.fn.expand("<cword>"))) end
