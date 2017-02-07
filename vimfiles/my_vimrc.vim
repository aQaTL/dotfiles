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
set expandtab
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

syntax on

set encoding=utf-8

source $VIMRUNTIME/mswin.vim
behave mswin

if has("gui_running")
	color torte
	set guifont=Consolas:h10:cDEFAULT
	set guioptions-=T
endif
