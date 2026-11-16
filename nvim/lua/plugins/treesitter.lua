-- nvim-treesitter (main branch) only installs parsers and queries. Highlighting is
-- started by neovim itself via vim.treesitter.start(). endwise and matchup attach on
-- their own (matchup's ruby opt-out lives in its lazy spec `init`).
local ts = require("nvim-treesitter")

ts.install({
    "bash",
    "c",
    "c_sharp",
    "css",
    "dart",
    "elixir",
    "go",
    "graphql",
    "html",
    "javascript",
    "json",
    "kotlin",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "ruby",
    "scss",
    "sql",
    "terraform",
    "vue",
    "yaml",
    "typescript",
    "tsx",
    "query",
    "vim",
})

-- Keep regex syntax running alongside treesitter for these (vim-jsx-pretty relies on it)
local regex_syntax_filetypes = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local start = function(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if not pcall(vim.treesitter.start, buf, lang) then return end
  if regex_syntax_filetypes[vim.bo[buf].filetype] then vim.bo[buf].syntax = "ON" end
end

-- Start highlighting on every filetype with a parser, installing missing ones on demand
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("__treesitter", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang then return end
    if vim.treesitter.language.add(lang) then return start(args.buf, lang) end
    if vim.tbl_contains(ts.get_available(), lang) then
      ts.install(lang):await(function() vim.schedule(function() start(args.buf, lang) end) end)
    end
  end,
})

-- https://joschua.io/posts/2023/06/22/set-up-nvim-for-astro/
-- https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
vim.filetype.add({ extension = { mdx = "mdx" } })
vim.treesitter.language.register("markdown", "mdx")

require("ufo").setup({
  provider_selector = function() return { "treesitter", "indent" } end,
})

local builtin = require("statuscol.builtin")
require("statuscol").setup({
  ft_ignore = { "neo-tree" },
  relculright = true,
  segments = {
    { sign = { name = { "Diagnostic" }, maxwidth = 1 } },
    { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
    { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
  },
})
