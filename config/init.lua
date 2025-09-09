-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", {noremap = false})
      vim.keymap.set("v", "ga", "<Plug>(EasyAlign)", {noremap = false})
    end,
  },
  {
    "tanvirtin/monokai.nvim",
    config = function()
      vim.cmd("colorscheme monokai_pro")
      vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({ensure_installed = {"c", "cpp", "lua", "python"}})
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {{"mason-org/mason.nvim", opts = {}}, "neovim/nvim-lspconfig"},
    opts = {},
    config = function()
      require("mason-lspconfig").setup({ensure_installed = {"clangd", "pyright"}})
      vim.keymap.set("n", "q", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(win).relative ~= "" then
            vim.api.nvim_win_close(win, false)
          end
        end
      end)
    end,
  },
})

-- Editor
vim.opt.autochdir = true
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false

vim.opt.cursorline = true
vim.diagnostic.config({signs = false, virtual_text = false, underline = false})
vim.opt.statusline = "%F"
vim.opt.wrap = true

-- Keymaps
vim.keymap.set("i"       , "<C-c>"   , "<Esc>")
vim.keymap.set("i"       , "<C-h>"   , "<C-o>b<C-o>dw") -- ^H maps to ^BS
vim.keymap.set("i"       , "<C-Del>" , "<C-o>dw")
vim.keymap.set("n"       , "<C-c>"   , vim.cmd.nohlsearch)
vim.keymap.set("n"       , "gb"      , "<cmd>pop<CR>")
vim.keymap.set("n"       , "gd"      , "<C-]>")

vim.keymap.set("n"       , "<C-e>"   , "<nop>")
vim.keymap.set("n"       , "Q"       , "<nop>")
vim.keymap.set({"n","v"} , "s"       , "<nop>")

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, "LineNr", {fg = "#4a4a4a", bg = "NONE"})
vim.api.nvim_set_hl(0, "CursorLineNr", {fg = "#ffa500", bg = "NONE"})

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Vimscript
vim.cmd [[
  " indents
  filetype indent off
  set expandtab tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType * setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2 formatoptions-=cro

  " search matches
  highlight CurSearch guibg=#ffa500
  highlight IncSearch guibg=#ffa500
]]
