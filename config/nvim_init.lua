vim.cmd('autocmd FileType * setlocal formatoptions-=cro shiftwidth=2 tabstop=2 softtabstop=2 expandtab')
vim.cmd "colorscheme unokai"
vim.cmd "syntax on"

vim.keymap.set({"n","v"}, "<C-c>", ":nohlsearch<CR>", { silent = true })
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
