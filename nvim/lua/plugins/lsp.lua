local get = require("lib.tables.get")

vim.diagnostic.config({ virtual_text = true })

require("mason").setup({})
require("mason-lspconfig").setup({
  automatic_enable = true,
  ensure_installed = {
    "bashls",
    "cssls",
    "dockerls",
    "emmet_language_server",
    "eslint",
    "jedi_language_server",
    "jsonls",
    "lua_ls",
    "solargraph",
    "ts_ls",
    "yamlls",
  },
})

-- Per-project opt-out: { "eslint": { "disable": true } } in .neovim.json
if get(project_config, { "eslint", "disable" }) then vim.lsp.enable("eslint", false) end

local flat_eslint_configs = {
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}
local legacy_eslint_configs = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
}
local has_any = function(root, names)
  return vim.iter(names):any(function(name) return vim.uv.fs_stat(root .. "/" .. name) ~= nil end)
end

-- ESLint 9 only reads flat config by default and errors out on a repo that still has an .eslintrc,
-- so fall back to eslintrc mode when the project root has a legacy config and no flat one.
local default_eslint_before_init = vim.lsp.config.eslint and vim.lsp.config.eslint.before_init
vim.lsp.config("eslint", {
  before_init = function(params, config)
    if default_eslint_before_init then default_eslint_before_init(params, config) end
    local root = config.root_dir
    if root and has_any(root, legacy_eslint_configs) and not has_any(root, flat_eslint_configs) then
      config.settings = config.settings or {}
      config.settings.useFlatConfig = false
      config.settings.experimental =
        vim.tbl_extend("force", config.settings.experimental or {}, { useFlatConfig = false })
    end
  end,
  on_attach = function(client, buffer)
    if not get(project_config, { "eslint", "disable_auto_fix" }) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = function(event)
          local diagnostics = vim.diagnostic.get(event.buf, { source = "eslint" })
          local eslint = function(formatter) return formatter.name == "eslint" end
          if #diagnostics > 0 then vim.lsp.buf.format({ async = false, filter = eslint }) end
        end,
      })
    end
  end,
})

local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = ".env",
  group = group,
  callback = function(args) vim.diagnostic.enable(false, { bufnr = args.buf }) end,
})
