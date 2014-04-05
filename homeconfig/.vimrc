set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
let mapleader = ","

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'grimpy/ctrlp.vim.git'
Bundle 'mileszs/ack.vim.git'
Bundle 'aklt/plantuml-syntax.git'
Bundle 'alfredodeza/pytest.vim.git'
Bundle 'tpope/vim-commentary.git'
Bundle 'kevinw/pyflakes-vim.git'
Bundle 'Shougo/neocomplcache.git'
Bundle 'tomasr/molokai'
Bundle 'Shougo/neosnippet.vim.git'
Bundle 'git://repo.or.cz/vcscommand'
Bundle 'sukima/xmledit.git'
Bundle 'scrooloose/nerdtree'
Bundle 'taglist.vim'
Bundle 'Buffergator'
Bundle 'davidhalter/jedi-vim'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-notes'
Bundle 'mhinz/vim-signify'

let g:jedi#popup_on_dot = 0
let g:jedi#usages_command = "<leader>u"
let g:jedi#use_tabs_not_buffers = 0

let python_highlight_all = 1
let python_version_2 = 1
let g:ctrlp_map = '<leader>f'

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au BufNewFile,BufRead *.wiki set filetype=confluencewiki
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_auto_close_preview = 1

let g:notes_directories = ['~/Documents/Notes']
let g:notes_suffix = '.txt'
let g:xmledit_enable_html = 1

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
set cursorline


vnoremap <leader>c "*y
nnoremap <leader>c "*yy
nnoremap <leader>v "*p
nnoremap <leader>R :source $MYVIMRC<CR>
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
nnoremap <leader>/ :noh<cr>
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeToggle<CR>
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F3> :TlistToggle<CR>
nnoremap <leader>m :only<CR>
nnoremap <leader>p :! autopep8-python2 --max-line-length=160 -i %<CR>
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
let NERDTreeIgnore = ['\.pyc$']

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
inoremap <F1> <Esc>

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
nnoremap <leader>h *<C-O>
