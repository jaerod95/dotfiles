local claude = require("claude-plan")
local map = require("config.functions.bind-key")

claude.setup()

map("n", "<leader>cc", claude.toggle, "[C]laude [C]ode toggle")
map("n", "<leader>cq", claude.question, "[C]laude [Q]uestion")
map("v", "<leader>cq", claude.question, "[C]laude [Q]uestion with selection")
map("n", "<leader>cn", claude.note, "[C]laude [N]ote")
map("n", "<leader>cw", claude.spec, "[C]laude [W]rite spec")
map("n", "<leader>cf", claude.specs, "[C]laude [F]ind specs")
map("n", "<leader>cx", claude.clear, "[C]laude clear session")
map("n", "<leader>ck", claude.stop, "[C]laude [K]ill process")
