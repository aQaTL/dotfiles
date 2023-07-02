filetype off

call plug#begin('~/.vim/plugged')

" Plug 'godlygeek/tabular' 
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
" Plug 'mattn/emmet-vim'
Plug 'chriskempson/base16-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-snippets'
" Plug 'altercation/vim-colors-solarized'
" Plug 'RustemB/sixtyfps-vim'
Plug 'pprovost/vim-ps1'
Plug 'morhetz/gruvbox'
Plug 'OmniSharp/omnisharp-vim'
Plug 'airblade/vim-gitgutter'
Plug 'AndrewRadev/typewriter.vim', {'branch': 'main'}
 
"Go auto import
let g:go_fmt_command = "goimports"

"Fix rust indentation
let g:rust_recommended_style = 0

" Automatically close nerdtree after opening a file
let NERDTreeQuitOnOpen = 1

call plug#end()

filetype plugin indent on

let g:vim_markdown_frontmatter = 1

set updatetime=50

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap gd <Plug>(coc-definition)
nmap <F7> <Plug>(coc-references)
inoremap <silent><expr> <c-@> coc#refresh()

" Show show documentation in a preview window
nnoremap <silent> <F1> :call ShowDocumentation()<CR>
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction

nmap <leader><F1> <Plug>(coc-codeaction-cursor)

nmap <F3> <Plug>(coc-diagnostic-next)
nmap <leader><F3> <Plug>(coc-diagnostic-prev)

" Symbol renaming
nmap <F2> <Plug>(coc-rename)

autocmd CursorHold * silent call CocActionAsync('highlight')

" Show current file in tree
nmap <F8> :NERDTreeFind<CR>

" Remap <C-f> and <C-b> to scroll float windows/popups
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Format current buffer
nmap <F4> :call CocActionAsync('format')<CR>

" Current document sybmols
nmap <silent><nowait> <F9> :<C-u>CocList outline<CR>
" Workspace sybmols
nmap <silent><nowait> <leader><leader> :<C-u>CocList -I symbols<CR>

" Next item in Coc list
nmap <F5> :CocPrev<CR>
nmap <F6> :CocNext<CR>
nmap <leader><F5> :CocListResume<CR>

let base16colorspace=256  " Access colors present in 256 colorspace
set background=dark
" colorscheme base16-apathy
" colorscheme solarized
colorscheme gruvbox

if has("win32") && !has("gui_running")
	colorscheme default
endif

if has("unix") && !has("gui_running")
	let s:uname = substitute(system("echo -n \"$(uname)\""), '\n', '', '')
	if s:uname == "Darwin"
		colorscheme default
	elseif s:uname == "Linux"
		colorscheme gruvbox
	elseif s:uname == "MINGW64_NT-10.0-19041"
		colorscheme default
	endif
endif

map <C-n> :NERDTreeToggle<CR>

" Enable .60 files automatic recognition
autocmd BufEnter *.60 :setlocal filetype=sixtyfps

