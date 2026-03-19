return function()
  diffview_mode = "master"
  vim.cmd(':call setqflist(map(systemlist("git diff --name-only master"), \'{"filename": v:val, "lnum": 1}\'))')
  vim.cmd(":copen")
end
