local get = require("lib.tables.get")

local width_percentage = get(project_config, { "filetree", "width" }, 32) / 100
local is_widescreen = vim.o.columns > 172
local width = is_widescreen and math.floor(vim.o.columns * width_percentage) or 40

require("neo-tree").setup({
  close_if_last_window = true,
  default_component_configs = {
    file_size = {
      enabled = false,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = false,
    },
    git_status = {
      symbols = {
        added = "",
        modified = "",
        deleted = "",
        renamed = "",
        untracked = "",
        ignored = "",
        unstaged = "",
        staged = "",
        conflict = "",
      },
    },
  },
  enable_git_status = true,
  enable_diagnostics = false,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
  },
  window = {
    position = "right",
    width = width,
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local args = vim.fn.argv()

    local start_inital_command = false
    for _, arg in ipairs(vim.v.argv) do
      if arg:match("^%+") then
        start_inital_command = true
        break
      end
    end

    if #args == 0 and not start_inital_command then
      require("neo-tree.command").execute({ focus = true, dir = vim.fn.getcwd() })
      vim.cmd("set nofoldenable")
    end
  end,
})
