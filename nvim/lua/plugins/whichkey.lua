local which_key = require("which-key")

which_key.setup({
  preset = "helix",
  delay = 400,
})

which_key.add({
  { "<leader>g", group = "git" },
})
