local get = require("lib.tables.get")

return function()
  local current_file_path = vim.fn.expand("%:p")
  local file_path_extension = get(project_config, { "open_test", "test_file_extension" }, ".spec.js")
  local test_file_path = string.gsub(current_file_path, ".js", file_path_extension)

  vim.cmd("edit " .. test_file_path)
end
