set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'bling/vim-airline'
Plug 'aklt/plantuml-syntax'
Plug 'alfredodeza/pytest.vim'
Plug 'kevinw/pyflakes-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'junegunn/fzf'
Plug 'roxma/nvim-completion-manager'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-signify'
Plug 'ruanyl/vim-gh-line'
Plug 'vim-scripts/BufOnly.vim'
Plug 'fatih/vim-go'
Plug 'gcmt/taboo.vim'
Plug 'dzhou121/gonvim-fuzzy'
Plug 'equalsraf/neovim-gui-shim'

call plug#end()

