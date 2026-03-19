return function()
  diffview_mode = "head"
  vim.cmd(':call setqflist(map(systemlist("git diff --name-only HEAD"), \'{"filename": v:val, "lnum": 1}\'))')
  vim.cmd(":copen")
end
