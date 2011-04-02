syn on
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set filetype=on
autocmd FileType python compiler pylint
let g:pylint_onwrite = 0
