require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  highlight_overrides = {
    all = function(colors)
      return {
        ["@variable"] = { fg = colors.maroon },
        ["@lsp.type.variable"] = { fg = colors.maroon },
        ["@property"] = { fg = colors.lavender },
        ["@type.builtin"] = { fg = colors.yellow },
        ["@variable.member"] = { fg = colors.lavender },
      }
    end,
  },
  transparent_background = true, -- disables setting the background color.
  term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
})
vim.cmd.colorscheme("catppuccin")

local ctp_feline = require("catppuccin.special.feline")
require("feline").setup({
  components = ctp_feline.get_statusline(),
  force_inactive = {
    filetypes = {
      "^neo%-tree$",
    },
  },
})

require("gitsigns").setup()

-- Diff highlights (matched to delta theme in .gitconfig)
vim.cmd([[hi DiffAdd guibg=#003500]])
vim.cmd([[hi DiffChange guibg=#003500]])
vim.cmd([[hi DiffDelete guifg=#5E0000 guibg=#5E0000]])
vim.cmd([[hi DiffText guibg=#007E5E]])

vim.cmd([[hi NotificationInfo guifg=#FFFFFF guibg=#0F111A]])
vim.cmd([[hi NotificationWarning guifg=#FFFFFF guibg=#0F111A]])
vim.cmd([[hi NotificationError guifg=#FFFFFF guibg=#0F111A]])
vim.cmd([[hi TelescopeNormal guibg=#0F111A]])
vim.cmd([[hi TelescopeBorder guibg=#0F111A]])
vim.cmd([[hi MasonNormal guibg=#161926]])
vim.cmd([[hi NormalFloat guibg=#161926]])

-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end
