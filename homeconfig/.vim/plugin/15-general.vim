let mapleader = ","

au BufNewFile,BufRead *.wiki set filetype=confluencewiki

autocmd BufWritePost .vimrc source $MYVIMRC
autocmd BufWritePost .vimrc filetype plugin indent on

set t_Co=256
set background=dark

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smartcase
set mouse=a
set guifont=Monospace\ 8
set fdm=indent
set foldlevel=30
set hlsearch
set cursorline
set ignorecase
set smartcase
set clipboard=unnamedplus
set wildmenu

if has('gui_running')
    colorscheme molokai
else
    colorscheme molokai
endif
