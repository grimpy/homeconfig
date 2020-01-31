set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

" Plantuml
Plug 'aklt/plantuml-syntax'
" Capnpn
Plug 'cstrahan/vim-capnp'
" Python
Plug 'alfredodeza/pytest.vim'
Plug 'heavenshell/vim-pydocstring'
Plug 'davidhalter/jedi-vim'
" GO
Plug 'fatih/vim-go'
" Git
Plug 'mhinz/vim-signify'
Plug 'ruanyl/vim-gh-line'
" Tim's stuff
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
" Guake like terminal
Plug 'Lenovsky/nuake'
" NErdtree
Plug 'scrooloose/nerdtree'
" Swap args around
Plug 'machakann/vim-swap'
" Snitppets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Completion
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-ultisnips'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/float-preview.nvim'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-go'
Plug 'ncm2/ncm2-markdown-subscope'
Plug 'ncm2/ncm2-html-subscope'
" Validator
Plug 'dense-analysis/ale'
" Gui stuff
Plug 'vim-scripts/BufOnly.vim'
Plug 'dzhou121/gonvim-fuzzy'
Plug 'gcmt/taboo.vim'
Plug 'bling/vim-airline'
Plug 'equalsraf/neovim-gui-shim'
Plug 'joshdick/onedark.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"Others
Plug 'junegunn/fzf.vim'
" Plug 'liuchengxu/vim-clap'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
call plug#end()
