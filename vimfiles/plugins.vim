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

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
