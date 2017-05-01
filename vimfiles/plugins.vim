filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('$HOME/vimfiles/bundle/')

Plugin 'VundleVim/Vundle.vim'

Plugin 'godlygeek/tabular' 
Plugin 'plasticboy/vim-markdown'
Bundle 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on

if has('gui_running')
	set background=dark
	colorscheme solarized

	let g:vim_markdown_frontmatter = 1
endif
