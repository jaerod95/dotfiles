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

require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = require("config.functions.bind-key")
    local opts = { buffer = bufnr }

    -- Navigation between hunks
    map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk", opts)
    map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk", opts)

    -- Stage / discard hunks (VS Code-like inline controls)
    map("n", "<leader>gs", gs.stage_hunk, "[G]it [S]tage hunk", opts)
    map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[G]it [S]tage selected lines", opts)
    map("n", "<leader>gu", gs.undo_stage_hunk, "[G]it [U]ndo stage hunk", opts)
    map("n", "<leader>gx", gs.reset_hunk, "[G]it discard hunk", opts)
    map("v", "<leader>gx", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "[G]it discard selected lines", opts)
    map("n", "<leader>gS", gs.stage_buffer, "[G]it [S]tage entire buffer", opts)
    map("n", "<leader>gX", gs.reset_buffer, "[G]it discard entire buffer", opts)

    -- Preview hunk
    map("n", "<leader>gv", gs.preview_hunk_inline, "[G]it [V]iew hunk inline", opts)
    map("n", "<leader>gV", gs.preview_hunk, "[G]it [V]iew hunk in popup", opts)
  end,
})

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
