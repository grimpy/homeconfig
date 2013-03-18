runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
" python mode

let mapleader = ","

let g:ctrlp_map = '<leader>f'
"let g:ctrlp_regexp = 1

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_auto_close_preview = 1

let g:notes_directory = '~/Documents/Notes'

" some defaults
filetype off
filetype plugin indent on
syn on
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smartcase
set filetype=on
set mouse=a
set guifont=Monospace\ 8
set fdm=indent
set foldlevel=30
set hlsearch

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
nnoremap <leader>/ :noh<cr>
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>m :only<CR>
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest end<CR>
nmap <silent><Leader>ts <Esc>:Pytest session<CR>


nmap <f5> :make<CR>

nmap <leader>a <Esc>:Ack!
imap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>
inoremap jj <ESC>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Right_Window = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
if has('gui_running')
    colorscheme  desert
else
    colorscheme  evening
endif

highlight Pmenu guibg=purple gui=bold
highlight PmenuSel guibg=red gui=bold
highlight Pmenu ctermbg=blue ctermfg=white gui=bold
highlight PmenuSel ctermbg=red ctermfg=white gui=bold

" save root files while not root
cmap w!! w !sudo tee % >/dev/null
