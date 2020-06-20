filetype off

call plug#begin('~/.vim/plugged')

Plug 'godlygeek/tabular' 
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'mattn/emmet-vim'
Plug 'chriskempson/base16-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-snippets'
Plug 'altercation/vim-colors-solarized'

"Go auto import
let g:go_fmt_command = "goimports"

"Fix rust indentation
let g:rust_recommended_style = 0

call plug#end()

filetype plugin indent on

if has('gui_running')
	let g:vim_markdown_frontmatter = 1

	let base16colorspace=256  " Access colors present in 256 colorspace
	set background=dark
	" colorscheme base16-apathy
	colorscheme solarized
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
