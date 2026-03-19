local describe_table = require("lib.databases.postgres.describe-table")
local list_table = require("lib.databases.postgres.list-table")

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_hide_schemas = { "pg_catalog", "pg_toast.*" }

vim.g.db_ui_table_helpers = {
  postgresql = {
    List = list_table,
    Insert = [[
SELECT string_agg(quote_ident(column_name), ', ' ORDER BY ordinal_position)
FROM information_schema.columns
WHERE table_name = '{table}' AND table_schema = '{dbname}';

INSERT INTO "{dbname}"."{table}" ()
VALUES ();]],
    Summary = describe_table,
  },
}
