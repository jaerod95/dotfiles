return function()
  diffview_mode = "pr-review"
  local file = io.open("/tmp/git-comment-base.txt")
  if file then
    local base = file:read()
    file:close()
    vim.cmd(
      ':call setqflist(map(systemlist("git diff --name-only '
        .. base
        .. ' -- \':!*index.spec.js\'"), \'{"filename": v:val, "lnum": 1}\'))'
    )
    vim.cmd(":copen")
  else
    print("Error reading  tmp file.")
  end
end
