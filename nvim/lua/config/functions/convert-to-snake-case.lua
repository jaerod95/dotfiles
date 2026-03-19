local to_snake_case = require("lib.strings.to-snake-case")

return function() vim.cmd("normal ciw" .. to_snake_case(vim.fn.expand("<cword>"))) end
