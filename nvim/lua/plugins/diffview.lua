local actions = require("diffview.actions")
local functions = require("config.functions")

diffview_mode = "git-diff" -- "git-diff" or "pr-review"

require("diffview").setup({
  keymaps = {
    diff2 = {
      {
        "n",
        "<C-n>",
        function()
          vim.cmd("DiffviewClose")
          vim.cmd("cn")
          functions.open_git_file_diff()
        end,
        { desc = "Open the diff for the next file" },
      },
      {
        "n",
        "<C-p>",
        function()
          vim.cmd("DiffviewClose")
          vim.cmd("cp")
          functions.open_git_file_diff()
        end,
        { desc = "Open the diff for the previous file" },
      },
    },
    view = {
      { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
    },
    file_panel = {
      { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
    },
    file_history_panel = {
      { "n", "<C-n>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
      { "n", "<C-p>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
    },
  },
})
