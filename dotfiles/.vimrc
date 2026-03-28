set autoindent
set clipboard=unnamedplus
set number
set relativenumber
autocmd BufEnter * setlocal formatoptions-=cro shiftwidth=3 tabstop=3 softtabstop=3 noexpandtab

"
" COLORS
" https://vimdoc.sourceforge.net/htmldoc/syntax.html
"

colorscheme unokai
highlight Normal ctermbg=none
let s:c_fixed_width_type_keywords = 'u8 u16 u32 u64 i8 i16 i32 i64 f32 f64'
let s:c_type_pattern = '\<[A-Z][A-Za-z0-9_]*[a-z][A-Za-z0-9_]*\>' " CamelCase or CamelSnake_HYBRID 
let s:c_macro_pattern = '\<[A-Z][A-Z0-9_]*\>' " SCREAMING_SNAKE_CASE

augroup c_extra_syntax_highlights
	autocmd Syntax c syntax case ignore
	autocmd Syntax c execute 'syntax keyword Type ' . s:c_fixed_width_type_keywords
	autocmd Syntax c syntax case match
	autocmd Syntax c execute 'syntax match Type /' . s:c_type_pattern . '/'
	autocmd Syntax c execute 'syntax match Constant /' . s:c_macro_pattern . '/ display containedin=ALLBUT,cComment,cCommentL,cString,cCharacter,cCppOut,cCppOut2,cCppSkip,cIncluded'
augroup END

"
" REMAPS
"

let mapleader = ' '
nnoremap <C-c> <cmd>silent! nohlsearch<CR>
inoremap <C-c> <Esc>
cnoremap <C-c> <Esc>
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <expr> <leader>e ':e ' . expand('%:p:h') . '/'
xnoremap <silent> <leader>y y:call system('wl-copy', @")<CR>

function! s:AlignDelim(after) abort
	let l:delim = input('Delimiter: ')
	if empty(l:delim)
		return
	endif

	let l:start = getpos("'<")
	let l:end = getpos("'>")
	let l:start_row = min([l:start[1], l:end[1]])
	let l:end_row = max([l:start[1], l:end[1]])

	if visualmode() ==# 'V'
		let l:start_col = 1
	else
		let l:start_col = min([l:start[2], l:end[2]])
	endif

	let l:max_delim = 0
	let l:positions = []

	for l:lnum in range(l:start_row, l:end_row)
		let l:text = getline(l:lnum)
		let l:search_from = max([l:start_col - 1, 0])
		let l:match_col = stridx(l:text, l:delim, l:search_from)

		if l:match_col >= 0
			let l:col = l:match_col + 1
			call add(l:positions, [l:lnum, l:col])
			let l:max_delim = max([l:max_delim, l:col])
		else
			call add(l:positions, [l:lnum, 0])
		endif
	endfor

	for [l:lnum, l:col] in l:positions
		if l:col <= 0
			continue
		endif

		let l:spaces = repeat(' ', l:max_delim - l:col)
		if empty(l:spaces)
			continue
		endif

		let l:text = getline(l:lnum)
		if a:after
			let l:insert_col = l:col - 1
		else
			let l:insert_col = l:start_col - 1
		endif

		let l:newtext = strpart(l:text, 0, l:insert_col) . l:spaces . strpart(l:text, l:insert_col)
		call setline(l:lnum, l:newtext)
	endfor
endfunction

xnoremap <silent> <leader>> :<C-u>call <SID>AlignDelim(1)<CR>
xnoremap <silent> <leader>< :<C-u>call <SID>AlignDelim(0)<CR>
