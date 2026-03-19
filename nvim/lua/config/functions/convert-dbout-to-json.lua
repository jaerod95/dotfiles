return function()
  vim.cmd("tabnew")
  vim.cmd("0r !~/.dotfiles/nvim/scripts/convert-dbout-to-json.mjs < #")
  vim.cmd("setlocal buftype=nofile bufhidden=delete noswapfile filetype=json")
  vim.cmd("normal! gg")
end
