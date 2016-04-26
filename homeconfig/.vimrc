set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'bling/vim-airline'
Plug 'aklt/plantuml-syntax'
Plug 'alfredodeza/pytest.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'kevinw/pyflakes-vim'
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/unite.vim'
Plug 'tomasr/molokai'
Plug 'git://repo.or.cz/vcscommand'
Plug 'scrooloose/nerdtree'
Plug 'taglist.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'
Plug 'mhinz/vim-signify'
Plug 'vim-scripts/BufOnly.vim'
Plug 'fatih/vim-go'
Plug 'gcmt/taboo.vim'

call plug#end()
