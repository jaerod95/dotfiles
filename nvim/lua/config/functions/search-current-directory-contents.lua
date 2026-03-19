local telescope = require("telescope")

return function()
  telescope.extensions.live_grep_args.live_grep_args({
    cwd = vim.fn.expand("%:p:h"),
    previewer = false,
  })
end
