local get = require("lib.tables.get")

return function()
  vim.cmd("Neotree close")
  local enter = " 'C-m' ;"

  local default_run_test_command = "'yarn test " .. vim.fn.expand("%:p") .. "'"
  local run_test_command = get(project_config, { "debug_test", "command" }, default_run_test_command)

  vim.cmd(
    ":silent !tmux list-panes | wc -l | grep 2 || (tmux split-window -h && tmux select-pane -t 1); tmux send-keys -t 2 "
      .. run_test_command
      .. enter
  )
end
