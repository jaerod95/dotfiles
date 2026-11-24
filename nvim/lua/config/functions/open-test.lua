local test_file = require("lib.javascript.test-file")

-- Toggles between a source file and its colocated test.
return function()
  local current_file = vim.fn.expand("%:p")
  local target = test_file.source_for(current_file) or test_file.test_for(current_file)
  if not target then return vim.notify("Not a JavaScript/TypeScript file", vim.log.levels.WARN) end
  vim.cmd.edit(vim.fn.fnameescape(target))
end
