call pathogen#runtime_append_all_bundles()
" python mode
let g:pymode_lint = 0
let g:pymode_options_other = 0

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
