require("nvim-treesitter.configs").setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
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
        "python",
        "ruby",
        "scss",
        "sql",
        "swift",
        "terraform",
        "vue",
        "yaml",
        "typescript",
        "tsx",
        "query",
        "vim"
    },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {"go", "javascript", "typescript", "jsx", "tsx"}
    }
}

require("ufo").setup(
    {
        provider_selector = function()
            return {"treesitter", "indent"}
        end
    }
)

local builtin = require("statuscol.builtin")
require("statuscol").setup(
    {
        ft_ignore = {"neo-tree"},
        relculright = true,
        segments = {
            {sign = {name = {"Diagnostic"}, maxwidth = 1}},
            {text = {builtin.foldfunc, " "}, click = "v:lua.ScFa"},
            {text = {builtin.lnumfunc, " "}, click = "v:lua.ScLa"}
        }
    }
)
