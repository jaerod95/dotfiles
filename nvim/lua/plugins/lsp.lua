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

vim.lsp.config("eslint", {
  on_init = function(client)
    if get(project_config, { "eslint", "use_global_node_module" }) then
      local bin = os.getenv("NVM_BIN")
      client.config.settings.nodePath = bin .. "/../lib/node_modules"
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
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
