-- Editor
vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false

-- Visuals
vim.opt.number = true
vim.opt.statusline = "%F"
vim.opt.wrap = false
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Format
vim.cmd("filetype indent off")
vim.cmd("autocmd FileType * setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 formatoptions-=cro")

-- Keymaps
vim.keymap.set("i"       , "<C-h>"   , "<C-w>") -- most terminals interpret ctrl-h as ctrl-backspace
vim.keymap.set("i"       , "<C-Del>" , "<C-o>dw")
vim.keymap.set("i"       , "<C-c>"   , "<Esc>")
vim.keymap.set("n"       , "<C-b>"   , "<C-v>")
vim.keymap.set("n"       , "<C-c>"   , function() if vim.v.hlsearch == 1 then vim.cmd("nohlsearch") end end)
vim.keymap.set("n"       , "<C-e>"   , "<nop>")
vim.keymap.set("n"       , "Q"       , "<nop>")
vim.keymap.set("n"       , "gb"      , "<cmd>pop<CR>")
vim.keymap.set("n"       , "gd"      , "<C-]>")
vim.keymap.set({"n","v"} , "<C-d>"   , "<C-d>zz")
vim.keymap.set({"n","v"} , "<C-u>"   , "<C-u>zz")
vim.keymap.set({"n","v"} , "s"       , "<nop>")
