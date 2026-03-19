local functions = require("config.functions")
local partial = require("lib.functions.partial")

vim.api.nvim_create_user_command("DBUIOpenLocal", partial(functions.open_database_connection, "local_apigateway"), {})
vim.api.nvim_create_user_command("DBUIOpenProduction", partial(functions.open_database_connection, "production"), {})
vim.api.nvim_create_user_command("DBUIOpenStaging", partial(functions.open_database_connection, "staging"), {})
vim.api.nvim_create_user_command("DBUIOpenDemo", partial(functions.open_database_connection, "demo"), {})
vim.api.nvim_create_user_command("DBUIOpenQA", partial(functions.open_database_connection, "qa"), {})
