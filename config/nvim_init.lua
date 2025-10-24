vim.cmd "syntax on"
vim.cmd "colorscheme unokai"
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt.tabstop = 2
vim.cmd('autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab')
