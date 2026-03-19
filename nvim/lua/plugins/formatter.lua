local util = require("formatter.util")
local function rubocop()
  return {
    exe = "rubocop",
    args = {
      "--autocorrect-all",
      "--stdin",
      util.escape_path(util.get_current_buffer_file_name()),
      "--format",
      "files",
      "--stderr",
    },
    stdin = true,
  }
end

require("formatter").setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    css = { require("formatter.filetypes.css").prettier },
    html = { require("formatter.filetypes.html").prettier },
    graphql = { require("formatter.filetypes.graphql").prettier },
    javascript = { require("formatter.filetypes.javascript").prettier },
    javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
    json = { require("formatter.filetypes.json").prettier },
    typescript = { require("formatter.filetypes.typescript").prettier },
    typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
    lua = { require("formatter.filetypes.lua").stylua },
    ruby = { rubocop },
    sh = { require("formatter.filetypes.sh").shfmt },
    vue = { require("formatter.filetypes.vue").prettier },
  },
})
