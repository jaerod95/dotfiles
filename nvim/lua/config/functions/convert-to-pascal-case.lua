local to_pascal_case = require("lib.strings.to-pascal-case")

return function() vim.cmd("normal ciw" .. to_pascal_case(vim.fn.expand("<cword>"))) end
