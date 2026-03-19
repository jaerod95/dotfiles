return function()
  if diffview_mode == "head" then
    vim.cmd("DiffviewOpen HEAD " .. vim.fn.expand("%:p"))
    vim.cmd("DiffviewToggleFiles")
  elseif diffview_mode == "master" then
    vim.cmd("DiffviewOpen origin/master " .. vim.fn.expand("%:p"))
    vim.cmd("DiffviewToggleFiles")
  elseif diffview_mode == "pr-review" then
    local file = io.open("/tmp/git-comment-base.txt")
    if file then
      local base = file:read()
      file:close()
      vim.cmd("DiffviewOpen " .. base .. " " .. vim.fn.expand("%:p"))
      vim.cmd("DiffviewToggleFiles")
    else
      print("Error reading tmp file.")
    end
  else
    vim.cmd("DiffviewOpen")
    vim.cmd("DiffviewToggleFiles")
  end
end
