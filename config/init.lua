-- Editor
vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false

-- Format
vim.cmd("filetype indent off")
vim.cmd("autocmd FileType * setlocal noexpandtab tabstop=1 shiftwidth=1 softtabstop=1 formatoptions-=cro")

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keymaps
vim.keymap.set("i"       , "<C-c>" , "<Esc>")
vim.keymap.set("n"       , "<C-e>" , "<nop>")
vim.keymap.set("n"       , "Q"     , "<nop>")
vim.keymap.set("n"       , "gb"    , "<cmd>pop<CR>")
vim.keymap.set("n"       , "gd"    , "<C-]>")
vim.keymap.set({"n","v"} , "s"     , "<nop>")

vim.keymap.set("n", "<C-c>", function()
	vim.cmd("nohlsearch")
	vim.fn.clearmatches()
end, { noremap = true, silent = true })

-- Visuals
vim.opt.number = true
vim.opt.statusline = "%F"
vim.opt.wrap = false
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

vim.api.nvim_create_user_command("HLT", function()
	vim.fn.matchadd("Search", "\\t")
end, {})
