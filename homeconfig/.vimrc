set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

" Plantuml
Plug 'aklt/plantuml-syntax'
" Capnpn
Plug 'peter-edge/vim-capnp'
" Python
Plug 'alfredodeza/pytest.vim'
Plug 'kevinw/pyflakes-vim'
"Plug 'zchee/deoplete-jedi'
"Plug 'davidhalter/jedi-vim'
" GO
Plug 'fatih/vim-go'
" Git
Plug 'mhinz/vim-signify'
Plug 'ruanyl/vim-gh-line'
" Tim's stuff
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
" Shougo stuff
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/denite.nvim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Guake like terminal
Plug 'Lenovsky/nuake'
" NErdtree
Plug 'scrooloose/nerdtree'
" Swap args around
Plug 'machakann/vim-swap'
" Completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-tmux'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-jedi'
Plug 'ncm2/ncm2-markdown-subscope'
Plug 'ncm2/ncm2-html-subscope'
" Gui stuff
Plug 'vim-scripts/BufOnly.vim'
Plug 'dzhou121/gonvim-fuzzy'
Plug 'gcmt/taboo.vim'
Plug 'bling/vim-airline'
Plug 'equalsraf/neovim-gui-shim'
Plug 'joshdick/onedark.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"Others

call plug#end()

