filetype off

set rtp+=~/.vim/bundle/Vundle.vim
if has("win32")
	call vundle#begin('$HOME/vimfiles/bundle/')
else
	call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular' 
Plugin 'plasticboy/vim-markdown'
Plugin 'scrooloose/nerdtree'
Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'
Plugin 'mattn/emmet-vim'
Plugin 'chriskempson/base16-vim'
Plugin 'aserebryakov/vim-todo-lists'
Plugin 'neoclide/coc.nvim'
Plugin 'neoclide/coc-snippets'

"Go auto import
let g:go_fmt_command = "goimports"

"Fix rust indentation
let g:rust_recommended_style = 0

call vundle#end()
filetype plugin indent on

if has('gui_running')
	let g:vim_markdown_frontmatter = 1

	let base16colorspace=256  " Access colors present in 256 colorspace
	set background=dark
	colorscheme base16-material
endif

map <C-n> :NERDTreeToggle<CR>

