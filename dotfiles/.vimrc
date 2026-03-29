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
autocmd FileType * setlocal formatoptions-=cro shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab

call plug#begin()
Plug 'crusoexia/vim-monokai'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'zivyangll/git-blame.vim'
call plug#end()

function! s:align_delim(after) abort
	let l:delim = input('Delimiter: ')
	if empty(l:delim)
		return
	endif
	let l:start_row = min([line("'<"), line("'>")])
	let l:end_row = max([line("'<"), line("'>")])
	let l:start_col = visualmode() ==# 'V' ? 1 : min([col("'<"), col("'>")])
	let l:search_from = l:start_col - 1
	let l:max_col = 0
	let l:matches = []
	for l:lnum in range(l:start_row, l:end_row)
		let l:col = stridx(getline(l:lnum), l:delim, l:search_from) + 1
		if l:col > 0
			call add(l:matches, [l:lnum, l:col])
			let l:max_col = max([l:max_col, l:col])
		endif
	endfor
	for [l:lnum, l:col] in l:matches
		let l:text = getline(l:lnum)
		let l:insert_col = a:after ? l:col - 1 : l:start_col - 1
		let l:new_text = strpart(l:text, 0, l:insert_col) . repeat(' ', l:max_col - l:col) . strpart(l:text, l:insert_col)
		call setline(l:lnum, l:new_text)
	endfor
endfunction

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
xnoremap <silent> <leader>> :<C-u>call <SID>align_delim(1)<CR>
xnoremap <silent> <leader>< :<C-u>call <SID>align_delim(0)<CR>

command! W w
