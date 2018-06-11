set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

" Plantuml
Plug 'aklt/plantuml-syntax'
" Python
Plug 'alfredodeza/pytest.vim'
Plug 'kevinw/pyflakes-vim'
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Guake like terminal
Plug 'Lenovsky/nuake'
" NErdtree
Plug 'scrooloose/nerdtree'
" Swap args around
Plug 'machakann/vim-swap'
" Gui stuff
Plug 'vim-scripts/BufOnly.vim'
Plug 'dzhou121/gonvim-fuzzy'
Plug 'gcmt/taboo.vim'
Plug 'bling/vim-airline'
Plug 'equalsraf/neovim-gui-shim'
Plug 'joshdick/onedark.vim'
"Others

call plug#end()

