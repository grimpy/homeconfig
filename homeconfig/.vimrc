set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/neobundle.vim/
let g:neobundle#types#git#clone_depth=5

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'aklt/plantuml-syntax.git'
NeoBundle 'alfredodeza/pytest.vim.git'
NeoBundle 'tpope/vim-commentary.git'
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'tpope/vim-sensible.git'
NeoBundle 'kevinw/pyflakes-vim.git'
NeoBundle 'Shougo/neocomplete.git'
NeoBundle 'Shougo/neosnippet.vim.git'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'tomasr/molokai'
NeoBundle 'git://repo.or.cz/vcscommand'
NeoBundle 'sukima/xmledit.git'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'taglist.vim'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'xolox/vim-misc'
NeoBundle 'xolox/vim-notes'
NeoBundle 'mhinz/vim-signify'
NeoBundle 'vim-scripts/BufOnly.vim'
NeoBundle 'fatih/vim-go'
NeoBundle 'gcmt/taboo.vim'

call neobundle#end()
