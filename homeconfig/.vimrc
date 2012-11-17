call pathogen#infect()
call pathogen#helptags()
" python mode

let mapleader = ","
let g:pymode_options = 0
let g:pymode_rope = 0
let g:pymode_lint_onfly = 1
let g:pymode_breakpoint = 0
let g:pymode_lint_hold = 1
let g:pymode_lint_ignore = "E301,E302,E501,E303,W901"

let g:ctrlp_map = '<leader>f'
let g:ctrlp_regexp = 1
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

let python = 'python2'
let pydoc = 'pydoc2'

" some defaults
filetype off
filetype plugin indent on
syn on
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set filetype=on
set mouse=a
set guifont=Monospace\ 8
set fdm=indent
set foldlevel=30
set hlsearch
nnoremap <leader>/ :noh<cr>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :only<CR>
nmap <leader>a <Esc>:Ack!
imap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>

inoremap jj <ESC>

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


" save root files while not root
cmap w!! w !sudo tee % >/dev/null
