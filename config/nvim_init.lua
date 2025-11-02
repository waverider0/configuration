vim.cmd('autocmd FileType * setlocal formatoptions-=cro shiftwidth=2 tabstop=2 softtabstop=2 expandtab')
vim.cmd "colorscheme unokai"
vim.cmd "syntax on"

vim.keymap.set({"i","n","v"}, "<C-c>", "<Esc>:nohlsearch<CR>", { silent = true })

vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
