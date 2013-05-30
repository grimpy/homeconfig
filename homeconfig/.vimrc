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
set t_Co=256
set background=dark
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
nnoremap <leader>N :NERDTreeToggle<CR>
nnoremap <leader>m :only<CR>
nnoremap <leader>p :! autopep8 --max-line-length=160 -i %<CR>
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest end<CR>
nmap <silent><Leader>ts <Esc>:Pytest session<CR>

" " Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

let g:neosnippet#snippets_directory='~/.vim/snippets'
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


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
    colorscheme molokai
else
    colorscheme molokai
endif

" save root files while not root
cmap w!! w !sudo tee % >/dev/null

" Reselect visual blockafter indent/outdent
vnoremap < <gv
vnoremap > >gv

" I can type :help on my own, thanks.
noremap <F1> <Esc>

" aleternate last two buffers
noremap <Leader><Leader> <C-^>
"remove paste mode after leaving insert mode
au InsertLeave * set nopaste
"move lines with alt key
noremap J :m+<CR>
noremap K :m-2<CR>
vnoremap J :m'>+<CR>gv
vnoremap K :m-2<CR>gv

"home and end mappings
noremap H ^
noremap L $
vnoremap H ^
vnoremap L $

"easy command mode
nnoremap ; :

