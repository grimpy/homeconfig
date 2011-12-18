call pathogen#runtime_append_all_bundles()
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
autocmd FileType python compiler pylint
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F3> :TlistToggle<CR>
nnoremap <silent> <F5> :Pylint<CR>:syn on<CR>

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Right_Window = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
let g:pylint_onwrite = 0
if has('gui_running')
    colorscheme  desert
else
    colorscheme  evening
endif
