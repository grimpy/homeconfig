call pathogen#runtime_append_all_bundles()
" python mode

let pymode_options_other = 0
let pymode_lint_onfly = 1
let pymode_lint_ignore = "E302,E501,E303"

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
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :TlistToggle<CR>
nnoremap <silent> <F5> :Pylint<CR>:syn on<CR>

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
