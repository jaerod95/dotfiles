return function()
  local thread_index = vim.fn.line(".")
  local quickfix_list = vim.fn.getqflist()
  local thread = quickfix_list[thread_index]

  if not thread or not thread.user_data then return print("No comment thread found at cursor") end

  local comment_id = thread.user_data.comment_id
  if not comment_id then return print("No comment id found for this comment") end

  local repo = vim.fn.trim(vim.fn.system("cat /tmp/git-comment-repo.txt"))
  local pr = vim.fn.trim(vim.fn.system("cat /tmp/git-comment-pr.txt"))

  vim.ui.input({ prompt = "Reply: " }, function(reply)
    if not reply or reply == "" then return end

    local command = string.format(
      [[gh api "repos/%s/pulls/%s/comments/%s/replies" -X POST -f body=%s]],
      repo,
      pr,
      comment_id,
      vim.fn.shellescape(reply)
    )

    local result = vim.fn.system(command)
    if vim.v.shell_error ~= 0 then return print("Failed to reply: " .. result) end

    quickfix_list[thread_index].text = thread.text .. "\n@kadenbarlow: " .. reply
    vim.fn.setqflist(quickfix_list)
    print("Replied")
  end)
end
