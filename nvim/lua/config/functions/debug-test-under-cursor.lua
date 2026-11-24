local send_to_tmux_pane = require("lib.send-to-tmux-pane")
local test_command = require("lib.javascript.test-command")
local test_file = require("lib.javascript.test-file")

local test_blocks = { "it", "test", "describe" }

-- Finds the nearest it/test/describe at or above the cursor and returns its name.
local find_test_name = function()
  for line_number = vim.fn.line("."), 1, -1 do
    local line = vim.fn.getline(line_number)
    for _, block in ipairs(test_blocks) do
      -- matches it("name", it.only('name', describe.each(...)(`name`, ...
      local _, name = line:match("^%s*" .. block .. "[%.%w]*%(%s*(['\"`])(.-)%1")
      if name then return name end
    end
  end
  return nil
end

-- Runs only the test under the cursor in the tmux pane to the right.
return function()
  local file = vim.fn.expand("%:p")
  if not test_file.is_test(file) then return vim.notify("Not in a test file", vim.log.levels.WARN) end

  local name = find_test_name()
  if not name then return vim.notify("No it/test/describe above the cursor", vim.log.levels.WARN) end

  vim.cmd("Neotree close")
  send_to_tmux_pane(test_command(file, name))
end
