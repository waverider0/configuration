vim.cmd "colorscheme unokai"
vim.cmd "syntax on"
vim.keymap.set({"i","n","v"}, "<C-c>", "<Esc>:nohlsearch<CR>", { silent = true })
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions:remove { 'c', 'r', 'o' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
