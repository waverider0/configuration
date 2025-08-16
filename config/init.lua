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
vim.cmd("autocmd FileType * setlocal noexpandtab tabstop=2 shiftwidth=2 softtabstop=2 formatoptions-=cro")

-- Keymaps
vim.keymap.set("i"       , "<C-c>" , "<Esc>")
vim.keymap.set("n"       , "<C-c>" , function() if vim.v.hlsearch == 1 then vim.cmd("nohlsearch") end end)
vim.keymap.set("n"       , "<C-e>" , "<nop>")
vim.keymap.set("n"       , "Q"     , "<nop>")
vim.keymap.set("n"       , "gb"    , "<cmd>pop<CR>")
vim.keymap.set("n"       , "gd"    , "<C-]>")
vim.keymap.set({"n","v"} , "s"     , "<nop>")
