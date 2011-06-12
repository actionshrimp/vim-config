set nocompatible
set backspace=indent,eol,start
set history=50
set ruler
set showcmd

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Use console dialogs instead of popup for simple choices
set guioptions+=c
"Remove toolbars, tearoffs and tabs
set guioptions-=tTe

set incsearch
set hlsearch
"Maps space to clear search highlighting
nmap <SPACE> <SPACE>:noh<CR>

if has('mouse')
	set mouse=a
endif

syntax on
set foldmethod=syntax
let g:xml_syntax_folding=1

filetype plugin indent on
set autoindent
autocmd FileType java setlocal omnifunc=javacomplete#Complete

"Autocomplete popup behavior
set completeopt+=longest,menuone

"Select an option with <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"Close the menu with escape
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
"Map C-space to use omnicomplete if available otherwise C-n behavior
inoremap <expr> <C-space> pumvisible() \|\| &omnifunc == '' ?
			\ "\<lt>C-n>" :
			\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
			\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
			\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"

"Styles, fonts and colourschemes
colorscheme desertmod

if has('win32')
	"Start maximized
	au GUIEnter * simalt ~x

	if hostname() == 'VDI-R004'
		set gfn=Lucida_Console:h9:cANSI
	else
		set gfn=Consolas:h9:cANSI
	endif
elseif has('unix')
	set gfn=Liberation\ Mono\ 9
endif

set list
if has('win32')
	set encoding=utf8
	set listchars=tab:›\ ,eol:¬
endif
if has('unix')
	set listchars=tab:▸\ ,eol:¬
endif

set ts=2 sw=2 sts=2 noet

"XPath plugin setting
if !has('python')
	let g:loaded_xpath = 1
endif

"Maps change current directory to that of current file
map <leader>cd :cd %:p:h<CR>:pwd<CR>

noremap <F3> :Sexplore<CR>
noremap <F4> :TlistAddFilesRecursive .<CR>:TlistToggle<CR>
noremap <F5> :GundoToggle<CR>

if has('win32')
	noremap <F6> :ConqueTermTab cmd<CR>
elseif has('unix')
	noremap <F6> :ConqueTermTab bash<CR>
endif

noremap <F7> :ConqueTermVSplit ipython<CR>
let g:ConqueTerm_CloseOnEnd = 1


if has('win32')
	set diffexpr=MyDiff()
	function! MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '""' . $VIMRUNTIME . '\diff"'
				let eq = '"'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction

	set backupdir=h:\documents\temp\vim

	command! Xv call Cmd_Shell("xmllint", expand("%"))
	command! -nargs=1 Xp call Cmd_Shell("xmllint --xpath \"", <q-args>, "\"", expand("%"))
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p
	\ | diffthis
endif
