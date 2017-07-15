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

Bundle 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on

if has('gui_running')
	set background=dark
	colorscheme solarized

	let g:vim_markdown_frontmatter = 1
endif

map <C-n> :NERDTreeToggle<CR>
