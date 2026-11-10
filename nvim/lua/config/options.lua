vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*" }, command = [[%s/\s\+$//e]] }) -- remove extra whitespace in file on save
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, { command = "checktime" }) -- reload files changed outside nvim
vim.opt.clipboard = "unnamed" -- copy to system clipboard from vim
vim.g.codeium_enabled = true -- can be toggled with <leader>tc
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.backup = false
vim.opt.colorcolumn = "120"
-- vim.api.nvim_create_autocmd({"BufEnter"}, {pattern = {"*.lua"}, command = [[syntax match spaces /  / conceal cchar= ]]})
-- vim.api.nvim_create_autocmd({"BufEnter"}, {pattern = {"*.lua"}, command = [[set conceallevel=1]]})
-- vim.opt.concealcursor = "nvi" -- works with the autocommand above and conceallevel option below to dispaly four spaces as two
vim.opt.cursorline = true -- highlights the line that the cursor is on
vim.opt.expandtab = true -- use spaces instead of tabs when pressing tab key
-- vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = "indent"
-- vim.opt.guicursor = "" -- use default terminal cursor
vim.opt.hlsearch = true -- highlight all occurances of search
vim.opt.ignorecase = true -- ignore case when searching, works with smartcase below
vim.opt.iskeyword:append("-")
vim.opt.incsearch = true -- show where search matches as typing instead of waiting for enter
vim.opt.isfname:append("@-@")
vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = false
vim.opt.scrolloff = 8
vim.opt.shell = "/bin/zsh"
vim.opt.shiftwidth = 2 -- number of spaces inserted when pressing tab
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true -- makes searches case sensitive when uppercase letters are included
vim.opt.smartindent = true -- indent when starting a new line
vim.opt.softtabstop = 2 -- number of spaces that a tab counts for
vim.opt.swapfile = false
vim.opt.tabstop = 2 -- number of spaces that a tab counts for
vim.opt.termguicolors = true
vim.opt.title = true -- enables showing title in tmux pane status bar
-- Files show as dir/dir/file. Terminal buffers (e.g. Claude Code opened through scrawl) would show
-- their whole "term://...//pid:env -u TMUX ... claude --flags" name, so show the title the program
-- sets instead (Claude sets "✳ <conversation topic>"), falling back to the program's name.
local file_titlestring = "%{expand('%:p:~:.:h:h:t')}/%{expand('%:p:~:.:h:t')}/%{expand('%:t')}%r%m"
function _G.nvim_titlestring()
  if vim.bo.buftype ~= "terminal" then return file_titlestring end

  local title = vim.b.term_title or ""
  -- b:term_title starts out as the buffer name until the program sets its own title
  if title ~= "" and not title:match("^term://") then return (title:gsub("%%", "%%%%")) end

  -- first word of the command that isn't env, an env flag or VAR=value
  local cmd = vim.api.nvim_buf_get_name(0):match("^term://.-//%d+:(.*)$") or ""
  local skip_next = false
  for word in cmd:gmatch("%S+") do
    if skip_next then
      skip_next = false
    elseif word == "-u" then
      skip_next = true
    elseif word ~= "env" and not word:match("^%-") and not word:match("^[%w_]+=") then
      return (vim.fn.fnamemodify(word, ":t"):gsub("%%", "%%%%"))
    end
  end
  return "terminal"
end
vim.opt.titlestring = "%{%v:lua.nvim_titlestring()%}"
-- nvim saves a program's new title in b:term_title but doesn't redraw the title until the next
-- keypress, and Claude retitles while you're idle, so refresh the title whenever it changes
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalTitle", { clear = true }),
  callback = function()
    vim.cmd([[call dictwatcheradd(b:, 'term_title', {-> timer_start(0, {-> execute('let &titlestring = &titlestring')})})]])
  end,
})
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.wrap = false -- can be toggled on and off with <leader>tw
vim.opt.wrapscan = false -- disable searches wrapping around the end of the file instead says no more matches
