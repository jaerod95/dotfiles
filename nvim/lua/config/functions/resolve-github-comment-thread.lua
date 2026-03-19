return function()
  local thread_index = vim.fn.line(".")
  local quickfix_list = vim.fn.getqflist()
  local thread = quickfix_list[thread_index]

  if not thread or not thread.user_data then return print("No comment thread found at cursor") end

  local thread_id = thread.user_data.thread_id
  if not thread_id then return print("No thread id found for this comment") end

  local command = string.format(
    [[gh api graphql -f query='mutation { resolveReviewThread(input: {threadId: "%s"}) { thread { isResolved } } }']],
    thread_id
  )

  local result = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then return print("Failed to resolve thread: " .. result) end

  table.remove(quickfix_list, thread_index)
  vim.fn.setqflist(quickfix_list)
  print("Resolved")
end
