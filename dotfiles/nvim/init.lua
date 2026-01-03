vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus" vim.opt.cursorline = true
vim.wo.relativenumber = true
vim.wo.number = true

vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro shiftwidth=2 tabstop=2 softtabstop=2 expandtab")
vim.cmd("colorscheme unokai")
vim.cmd("syntax on")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ww", ":set wrap! linebreak!<CR>", { silent = true })
vim.keymap.set({"i","n","v"}, "<C-c>", "<Esc>:nohlsearch<CR>", { silent = true })

local function align_delim(after)
  local delim = vim.fn.input('Delimiter: ')

  local start = vim.fn.getpos('v')
  local end_ = vim.fn.getpos('.')
  local start_row = math.min(start[2], end_[2])
  local start_col = vim.fn.mode() == 'V' and 1 or math.min(start[3], end_[3])
  local end_row = math.max(start[2], end_[2])

  local delim_positions = {}
  local lines = vim.api.nvim_buf_get_lines(0, start_row-1, end_row, false)
  for i, line in ipairs(lines) do delim_positions[i] = line:find(delim, start_col, true) or false end

  local max_delim = 0
  for _, col in ipairs(delim_positions) do
    if col and col > max_delim then max_delim = col end
  end

  for i, line in ipairs(lines) do
    local col = delim_positions[i]
    if col then
      local spaces = max_delim - col
      local row = start_row + i - 1
      if after then
        local insert_col = col - 1
        vim.api.nvim_buf_set_text(0, row-1, insert_col, row-1, insert_col, {string.rep(' ', spaces)})
      else
        local insert_col = start_col - 1
        vim.api.nvim_buf_set_text(0, row-1, insert_col, row-1, insert_col, {string.rep(' ', spaces)})
      end
    end
  end
end

vim.keymap.set("v", "<leader>>", function() align_delim(true) end, { silent = true })
vim.keymap.set("v", "<leader><", function() align_delim(false) end, { silent = true })
