set autoindent
set clipboard=unnamedplus
set guicursor=
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=0
set nobackup
set noerrorbells
set noshowmode
set noswapfile
set number
set relativenumber
set shortmess-=S
set termguicolors
set undodir=~/.vim/undo
set undofile
set wrap

filetype plugin indent on
autocmd FileType * setlocal formatoptions-=cro shiftwidth=3 tabstop=3 softtabstop=3 noexpandtab

call plug#begin()
Plug 'crusoexia/vim-monokai'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree'
Plug 'zivyangll/git-blame.vim'
call plug#end()

syntax on
colorscheme monokai
hi Normal guibg=NONE ctermbg=NONE

let mapleader = ' '
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
cnoremap <C-c> <Esc>
inoremap <C-c> <Esc>
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap <leader>e :Ex<CR>
nnoremap <leader>gb :<C-u>call gitblame#echo()<CR>
nnoremap <leader>n :nohlsearch<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>
nnoremap <leader>u :UndotreeShow<CR>
xnoremap <silent> <leader>y y:call system('wl-copy', @")<CR>

command! W w
