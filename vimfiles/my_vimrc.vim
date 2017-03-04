" Basic
set ruler
set nu
set visualbell

" Highlights current line
"set cursorline

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set smartindent

" Enabled folding on indent level. That way it works on any code & html, xml
" etc. 
" Setting foldlevelstart ensures that for newly opened files folds are open
" unless they are 10 levels deep.
set foldmethod=indent
set foldenable
set foldlevelstart=10
set foldnestmax=10      " no more than 10 fold levels please
set showmatch


" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Wildchar visual completion
set wildmenu
set wildmode=full

" Line wrapping and breaking for better reading
set wrap
set linebreak

" Spell checking
set spell spelllang=en_gb

syntax on

set encoding=utf-8

source $VIMRUNTIME/mswin.vim
behave mswin

if has("gui_running")
	if has("win32")
		set guifont=Ubuntu_Mono_derivative_Powerlin:h10:cEASTEUROPE:qDRAFT
	else
		set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 10
	endif

	color torte
	set guioptions-=T
	
	" Initial gvim window size
	set lines=60
	set columns=100
endif
