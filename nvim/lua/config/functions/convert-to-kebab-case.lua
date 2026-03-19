local to_kebab_case = require("lib.strings.to-kebab-case")

return function() vim.cmd("normal ciw" .. to_kebab_case(vim.fn.expand("<cword>"))) end
