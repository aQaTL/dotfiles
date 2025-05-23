" Fix powershell slowness by using bash instead ;)
if &shell =~ "pwsh"
	if has("unix")
		set shell=/bin/bash
	endif
endif

if &shell =~ "nu$"
	if has("unix")
		set shell=/bin/bash
	endif
endif

" Basic
syntax on
set ruler
set nu
set relativenumber
set novisualbell
set belloff=all
set nocompatible
set encoding=utf-8
set ttyfast

" Set leader key to space
let mapleader = "\<Space>"

" Veritical line at 100 characters
set colorcolumn=100

" Set color of that vertical line
hi ColorColumn ctermbg=lightgrey

" Always show status line, like neovim does by default
set laststatus=2

" Neovim cursor
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

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

if !has("nvim")
	" Turn off stupid esc lag
	set noesckeys
endif

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
set wildmode=longest:list,full

" Line wrapping and breaking for better reading
set wrap
set linebreak

" Unix line endings
set fileformat=unix

" Disable syntax highlighting for markdown files
" autocmd FileType markdown setlocal syntax=OFF 

" Enable spellcheck for markdown files
autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal spelllang=en

" Tweaks for builtin file browser
let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

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

inoremap jk <ESC>
inoremap kj <ESC>

inoremap JK <ESC>
inoremap KJ <ESC>

inoremap Jk <ESC>
inoremap Kj <ESC>

inoremap jK <ESC>
inoremap kJ <ESC>

vmap J :m '>+1<CR>gv=gv
vmap K :m -2<CR>gv=gv

nmap <C-l> <C-W><C-W>

nnoremap <space>n :nohl<ENTER>  

" Go to tab by index with <space>num

noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

" HTML auto-complete
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

"source $VIMRUNTIME/mswin.vim
"behave mswin

if has("gui_running")
	if has("unix") 
		let s:uname = substitute(system("echo -n \"$(uname)\""), '\n', '', '')
		if s:uname == "Darwin"
			set guifont=CascadiaCode-Regular:h16
		else
			set guifont=Cascadia\ Code\ 12
		endif
	endif
	
	if has("win32")
		set guifont=Cascadia_Code:h12
		set linespace=0
	endif
	
	color torte

	"Turn off menu bar, tool bar and vertical scroll bars
	set guioptions-=T
	set guioptions-=m
	set guioptions-=l
	set guioptions-=R
	set guioptions-=L
	set guioptions+=k

	set guicursor=n-v-c-sm:block-blinkwait0-blinkon0-blinkoff0,i-ci-ve:ver25-blinkwait0-blinkon0-blinkoff0,r-cr-o:hor20-blinkwait0-blinkon0-blinkoff0

	" Spell checking
	"set spell spelllang=en_us

	" Initial gvim window size
	set lines=50
	set columns=105

	" Highlights current line
	set cursorline
endif
