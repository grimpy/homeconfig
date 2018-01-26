set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'bling/vim-airline'
Plug 'aklt/plantuml-syntax'
Plug 'alfredodeza/pytest.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'kevinw/pyflakes-vim'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'tomasr/molokai'
Plug 'spolu/dwm.vim'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-signify'
Plug 'ruanyl/vim-gh-line'
Plug 'vim-scripts/BufOnly.vim'
Plug 'fatih/vim-go'
Plug 'gcmt/taboo.vim'
Plug 'dzhou121/gonvim-fuzzy'
Plug 'equalsraf/neovim-gui-shim'
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-completion-manager'

call plug#end()

