autocmd BufEnter * setlocal formatoptions-=cro shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

colorscheme unokai
highlight Normal ctermbg=none

let mapleader = ' '

nnoremap <C-c> <cmd>silent! nohlsearch<CR>
inoremap <C-c> <Esc>
cnoremap <C-c> <Esc>

nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

nnoremap <expr> <leader>e ':e ' . expand('%:p:h') . '/'
xnoremap <silent> <leader>y y:call system('wl-copy', @")<CR>

set autoindent
set clipboard=unnamedplus
set number
set relativenumber
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
