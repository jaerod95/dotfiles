return function()
  local first_option = true
  vim.lsp.buf.code_action({
    filter = function(action)
      if first_option and action.title:match("Clean namespace") then
        first_option = false
        return true
      end
    end,
    apply = true,
  })
  vim.schedule(function()
    vim.cmd("sleep 200m")
    vim.cmd("silent FormatWrite")
  end)
end
