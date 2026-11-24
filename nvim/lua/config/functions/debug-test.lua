local send_to_tmux_pane = require("lib.send-to-tmux-pane")
local test_command = require("lib.javascript.test-command")
local test_file = require("lib.javascript.test-file")

-- Runs the current test file (or the current source file's test) in the tmux pane to the right.
return function()
  vim.cmd("Neotree close")
  local file = vim.fn.expand("%:p")
  if not test_file.is_test(file) then file = test_file.test_for(file) end
  send_to_tmux_pane(test_command(file))
end
