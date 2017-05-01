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

" Use os clipboard instead of vim's internal one
set clipboard=unnamed

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

" Unix line endings
set fileformat=unix

" Undo, backup and swp organization
if has("win32")
	set undodir=C:\Users\Maciej\.vim\.undo\
	set backupdir=C:\Users\Maciej\.vim\.backup\
	set directory=C:\Users\Maciej\.vim\.swp\
else
	set undodir=~/.vim/.undo//
	set backupdir=~/.vim/.backup//
	set directory=~/.vim/.swp//
endif

" Templates
noremap ;go o{% highlight go %}<Esc>o<Esc>_o{% endhighlight %}<Esc>ki

syntax on

set encoding=utf-8

source $VIMRUNTIME/mswin.vim
behave mswin

if has("gui_running")
	if has("win32")
		set guifont=Ubuntu_Mono_derivative_Powerlin:h10:cEASTEUROPE:qDRAFT
	else
		set guifont=Ubuntu\ Mono\ 11
	endif

	color torte
	set guioptions-=T

	" Spell checking
	set spell spelllang=en_gb

	" Initial gvim window size
	set lines=60
	set columns=100
endif
