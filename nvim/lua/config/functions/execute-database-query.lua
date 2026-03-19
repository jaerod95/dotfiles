local find = require("lib.tables.find")

return function(sql, first, last)
  vim.cmd("silent DB " .. vim.b.db .. " " .. string.gsub(sql, "\n", " "))
  vim.wait(10)

  local results_buffer = find(vim.api.nvim_list_bufs(), function(bufnr) return vim.bo[bufnr].filetype == "dbout" end)

  while vim.api.nvim_buf_get_lines(results_buffer, 0, -1, false)[1] == "" do
    vim.wait(100)
  end

  return vim.api.nvim_buf_get_lines(results_buffer, first or 2, last or -1, false)
end
