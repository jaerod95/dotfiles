local get = require("lib.tables.get")

return function()
  vim.cmd("Neotree close")
  local enter = " 'C-m' ;"

  local path = vim.fn.expand("%:p")
  local path_function = get(project_config, { "debug_function", "path_function" })
  if path_function then
    local fn = load(string.format(path_function, path))
    if fn ~= nil then path = fn() end
  end

  local default_import_command = '{ default: fn } = await import("' .. path .. '")'
  local import_command = get(project_config, { "debug_function", "import_command" }, default_import_command)

  local default_repl_command = "yarn repl"
  local repl_command = get(project_config, { "debug_function", "repl_command" }, default_repl_command)

  vim.cmd(
    ":silent !tmux list-panes | wc -l | grep 2 || (tmux split-window -h && tmux send-keys -t 2 "
      .. "'"
      .. repl_command
      .. "'"
      .. enter
      .. ")"
  )
  vim.cmd(":silent !tmux send-keys -t 2 " .. "'" .. import_command .. "'" .. enter .. " tmux select-pane -t 2")
end
