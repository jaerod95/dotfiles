local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "nvim-lua/plenary.nvim", commit = "b9fd522", priority = 1000 }, -- needed by many other plugins as a dependency
    -- Telescope Plugins
    { "nvim-telescope/telescope-fzf-native.nvim", commit = "6fea601", build = "make" }, -- faster and more accurate fuzzy searching
    { "nvim-telescope/telescope-live-grep-args.nvim", commit = "53e9df5" }, -- pass args into telescope for searching by glob, type
    { "princejoogie/dir-telescope.nvim", commit = "805405b" }, -- search files within a specific directory
    { "nvim-telescope/telescope.nvim", tag = "0.1.4" }, -- all things searching
    --- Navigation Plugins
    { "folke/flash.nvim", commit = "fcea7ff", event = "VeryLazy" }, -- jump to location by key combo
    { "ThePrimeagen/harpoon", commit = "1bc17e3" }, -- bookmark and jump between several files
    { "stevearc/oil.nvim", commit = "0fcc838" }, -- edit directory structure as a buffer
    -- Text Editing Plugins
    { "ThePrimeagen/refactoring.nvim", commit = "6784b54" }, -- adds debug statements based on language, and other refactoring commands
    { "echasnovski/mini.splitjoin", commit = "9fcd885", version = "*" }, -- split and join lines of code
    { "tpope/vim-commentary", commit = "64a654e" }, -- comment out lines of code
    { "tpope/vim-fugitive", commit = "3b753cf" }, -- git functionality inside of vim
    { "tpope/vim-scriptease", commit = "4cc639d" }, -- open messages buffer and other helpful debugging functions
    { "tpope/vim-sleuth", commit = "be69bff" }, -- automatically detect indentation based on the current file
    { "tpope/vim-surround", commit = "3d188ed" }, -- change and add quotes and braces to selection
    -- Plugins for auto-closing blocks, tags, quotes, etc
    { "RRethy/nvim-treesitter-endwise", commit = "8fe8a95" }, -- adds end in ruby
    { "andymass/vim-matchup", commit = "0fb1e6b" }, -- extends vims % jumping to language specific keywords like end
    { "echasnovski/mini.pairs", commit = "42387c7" }, -- automatically adds character pairs for quotes and braces etc.
    { "windwp/nvim-ts-autotag", commit = "8e1c0a3", opts = {} }, -- automatically adds html/jsx end tags
    -- Plugins for making the editor look nice
    { "catppuccin/nvim", commit = "426dbeb", name = "catppuccin", priority = 1000 }, -- amazing looking colorscheme
    { "kadenbarlow/feline.nvim", commit = "3587f57" }, -- amazing looking status bar
    { "kevinhwang91/nvim-ufo", commit = "ab3eb12", dependencies = { { "kevinhwang91/promise-async", commit = "119e896" } } }, -- makes fold look modern
    { "lewis6991/gitsigns.nvim", commit = "cf1ffe6" }, -- git integration in buffers (pinned before vim.validate breaking change)
    { "luukvbaal/statuscol.nvim", commit = "c46172d" }, -- allows clicking of folds to expand and collapse
    { "maxmellon/vim-jsx-pretty", commit = "6989f16" }, -- make jsx look nice
    { "mbbill/undotree", commit = "6fa6b57" }, -- visually go back through edits
    { "norcalli/nvim-colorizer.lua", commit = "a065833" }, -- highlight hex and colors in buffers
    { "nvim-neo-tree/neo-tree.nvim", commit = "84c75e7", branch = "v3.x", dependencies = { { "MunifTanjim/nui.nvim", commit = "de74099" } } }, -- filetree sidebar
    { "nvim-tree/nvim-web-devicons", commit = "95b7a00" }, -- amazing looking icons
    { "pixelastic/vim-undodir-tree", commit = "f5cd177" }, -- fixes an issue with undo behavior with file names that are too long
    -- IDE Functionality
    -- { "Exafunction/codeium.vim", tag = "1.8.30" }, -- AI coding assistant
    { "L3MON4D3/LuaSnip", commit = "a62e108" }, -- snippet engine
    { "folke/trouble.nvim", commit = "bd67efe", opts = {} }, -- view lsp diagnostics across projects
    { "hrsh7th/cmp-buffer", commit = "b74fab3" }, -- adds a nvim-cmp source for text in the buffer
    { "hrsh7th/cmp-nvim-lsp", commit = "cbc7b02" }, -- adds a nvim-cmp source for the lsp server
    { "hrsh7th/cmp-path", commit = "c642487" }, -- adds a nvim-cmp source for file paths
    { "hrsh7th/nvim-cmp", commit = "a1d5048" }, -- completion plugin providing the dropdown list of options while coding
    { "kristijanhusak/vim-dadbod-completion", commit = "a8dac0b", ft = { "sql", "mysql", "plsql" } }, -- lsp for sql queries
    { "kristijanhusak/vim-dadbod-ui", commit = "07e92e2" }, -- ui for vim-dadbod which is a database viewer
    { "mhartington/formatter.nvim", commit = "b9d7f85" }, -- automatic code formatting
    { "neovim/nvim-lspconfig", commit = "c588db3" }, -- repository of neovim lsp configurations
    { "nvim-treesitter/nvim-treesitter", commit = "4916d65" }, -- syntax highlighting
    { "nvim-treesitter/nvim-treesitter-context", commit = "b0c45ce" }, -- shows code context at top of buffer
    { "saadparwaiz1/cmp_luasnip", commit = "98d9cb5" }, -- adds a nvim-cmp source for snippets
    { "sindrets/diffview.nvim", commit = "4516612" }, -- used for in editor github PR reviews
    { "tpope/vim-dadbod", commit = "6d1d41d" }, -- database viewer
    { "williamboman/mason-lspconfig.nvim", commit = "63a3c6a" }, -- bridges mason and nvim-lspconfig and makes working with them easy
    { "williamboman/mason.nvim", commit = "b03fb0f" }, -- package manager for installing lsp servers, linters, formatters etc
    -- Personal plugins
    { "jaerod95/scrawl.nvim" }, -- claude code planning integration
  },
  defaults = { pin = true },
  install = { colorscheme = { "catppuccin" } },
})
