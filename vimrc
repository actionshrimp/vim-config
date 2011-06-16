set nocompatible
set backspace=indent,eol,start
set history=50
set ruler
set showcmd
set hidden
"line numbers
set number

"case insensitive unless pattern contains uppercase
set ignorecase
set smartcase

"suppress lack of ctags warning
if has('win32')
	if !executable('ctags.exe')
		let loaded_taglist = 'yes'
	endif
endif

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"Use console dialogs instead of popup for simple choices
set guioptions+=c
"Remove toolbars, tearoffs and tabs
set guioptions-=t
set guioptions-=T
set guioptions-=e
set incsearch
set hlsearch

if has('mouse')
	set mouse=a
endif

syntax on
set foldmethod=syntax
let g:xml_syntax_folding=1

filetype plugin indent on
set autoindent
autocmd FileType java setlocal omnifunc=javacomplete#Complete
let g:java_classpath='H:\classpath\wm-isserver.jar;H:\classpath\wm-isclient.jar'

"Autocomplete popup behavior
set completeopt+=longest
set completeopt+=menuone

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


"""""""""""""""
"Plugin config
"""""""""""""""

"Set netrw to tree style
let g:netrw_liststyle=3

"SQL autocomplete settings
let g:omni_sql_ignorecase = 1
let g:omni_sql_include_owner = 0

"buftabs
autocmd WinEnter * call Buftabs_helper()

""""""""""""""""""
"Plugin functions
""""""""""""""""""
function! Buftabs_helper()
	if exists('*Buftabs_enable')
		call Buftabs_enable()
		call Buftabs_show(-1)
	endif
endfunction

function! PythonCheckPylint()
	let g:pyflakes_use_quickfix = 0
	set makeprg=pylint\ --reports=n\ --output-format=parseable\ %:p
	set errorformat=%f:%l:\ %m
	make
	cwindow
endfunction

function! PythonCheckPyflakes()
	let g:pyflakes_use_quickfix = 1
	PyflakesUpdate
	cwindow
endfunction

""""""""""""""
"Key bindings
""""""""""""""

"Standard

"Maps change current directory to that of current file
map <leader>cd :cd %:p:h<CR>:pwd<CR>

"Maps space to clear search highlighting
nmap <SPACE> <SPACE>:noh<CR>:call Buftabs_show(-1)<CR>

"Select an option with <CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"Close the menu with escape
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
"Map C-space to use omnicomplete if available otherwise C-n behavior
inoremap <expr> <C-space> pumvisible() \|\| &omnifunc == '' ?
			\ "\<lt>C-n>" :
			\ "\<lt>C-x>\<lt>C-o>"

"Indentation
nmap <C-h> <<
nmap <C-l> >>
vmap <C-h> <gv
vmap <C-l> >gv

"Move over wrapped lines
nmap <C-j> gj
nmap <C-k> gk

"Plugins

"netrw
noremap <F2> :Sexplore!<CR>
"minibufexplorer
noremap <F3> :FufBuffer<CR>
"fuzzyfinder
noremap <F4> :FufFileWithCurrentBufferDir<CR>
noremap <C-F4> :FufFile<CR>

"taglist
noremap <F5> :TlistAddFilesRecursive .<CR>:TlistToggle<CR>
"gundo
noremap <F6> :GundoToggle<CR>

noremap <F7> :call PythonCheckPyflakes()<CR>
noremap <F8> :call PythonCheckPylint()<CR><CR>

"NERDCommenter
vnoremap <C-k> :call NERDComment(1, "toggle")<CR>

"db-exec
if has('win32')
	source H:\_sql_connections
	inoremap <F9> <ESC>:normal vap<CR>:DBExecVisualSQL<CR><CR>
	noremap <F9> :normal vap<CR>:DBExecVisualSQL<CR><CR>
	noremap <F10> :DBPromptForBufferParameters<CR><BS>
endif
