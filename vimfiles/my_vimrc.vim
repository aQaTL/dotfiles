" Basic
syntax on
set ruler
set nu
set relativenumber
set novisualbell
set nocompatible
set encoding=utf-8
set ttyfast

" More natural splits placement 
set splitbelow
set splitright

" Recursive search
set path+=**

" Highlights current line
"set cursorline

" Indentation
set tabstop=4
set shiftwidth=4
set softtabstop=0
set noexpandtab
set smartindent

" Turn off stupid esc lag
set noesckeys

" Enabled folding on indent level. That way it works on any code & html, xml
" etc. 
" Setting foldlevelstart ensures that for newly opened files folds are open
" unless they are 10 levels deep.
set foldmethod=indent
set foldenable
set foldlevelstart=10
set foldnestmax=10      " no more than 10 fold levels please
set showmatch

" Sane backspace
set backspace=indent,eol,start

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

" Tweaks for builtin file browser
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Undo, backup and swp organization
if has("win32")
	set undodir=~/vimfiles/.undo/
	set backupdir=~/vimfiles/.backup/
	set directory=~/vimfiles/.swp/
else
	set undodir=~/.vim/.undo//
	set backupdir=~/.vim/.backup//
	set directory=~/.vim/.swp//
endif

" Templates
map ± :NERDTreeToggle<CR>
noremap ;go o{% highlight go %}<Esc>o<Esc>_o{% endhighlight %}<Esc>ki
noremap ;mgo ipackage main<Esc>o<Esc>oimport (<Esc>o	"fmt"<Esc>o<Esc>0c$)<Esc>o<Esc>ofunc main() {<Esc>o	<Esc>_o}<Esc>
noremap Æjs ! python -m json.tool<ENTER>
noremap <C-S> :w<ENTER>
noremap <C-C> "+y<ENTER>
noremap <C-V> "+p<ENTER>
inoremap <C-V> <C-R>*

" HTML auto-complete
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

"source $VIMRUNTIME/mswin.vim
"behave mswin

if has("gui_running")
	if has("unix") 
		let s:uname = system("echo -n \"$(uname)\"")
		if s:uname == "Darwin"
			set guifont=CascadiaCode-Regular:h15
		else
			set guifont=Cascadia\ Code\ 11
		endif
	endif
	
	if has("win32")
		set guifont=Cascadia_Code:h11
	endif
	
	color torte

	"Turn off menu bar, tool bar and vertical scroll bars
	set guioptions-=T
	set guioptions-=m
	set guioptions-=l
	set guioptions-=R
	set guioptions-=L

	set guicursor=i:blinkwait0-blinkon0-blinkoff0
	set guicursor=n:blinkwait0-blinkon0-blinkoff0
	set guicursor=v:blinkwait0-blinkon0-blinkoff0

	" Spell checking
	"set spell spelllang=en_us

	" Initial gvim window size
	set lines=60
	set columns=120
endif
