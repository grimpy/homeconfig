call pathogen#infect()
call pathogen#helptags()
" python mode

let mapleader = ","

let g:ctrlp_map = '<leader>f'
"let g:ctrlp_regexp = 1

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

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
nnoremap <leader>/ :noh<cr>
nnoremap <leader>n :NERDTreeToggle<CR>
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
highlight Pmenu ctermbg=blue ctermfg=white gui=bold

" save root files while not root
cmap w!! w !sudo tee % >/dev/null
