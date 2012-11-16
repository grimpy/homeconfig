call pathogen#infect()
" python mode

let mapleader = ","
let pymode_options_other = 0
let pymode_lint_onfly = 1
let pymode_breakpoint = 0
let pymode_lint_ignore = "E301,E302,E501,E303,W901"
let pydiction_location = '/usr/share/pydiction/complete-dict'

let g:ctrlp_map = '<leader>f'
let g:ctrlp_regexp = 1
let g:ctrlp_match_func = { 'match': 'MatchFunc' }
let g:path_to_binary = "/usr/bin/grep"

function! MatchFunc(items, str, limit, mmode, ispath, crfile, regex)
  " Create a cache file
  if (a:regex)
    return ctrlp#call('s:MatchIt', a:items, a:str, a:limit, a:crfile)
  else
    let cmd = g:path_to_binary.' -Rl '.a:str.' * 2> /dev/null'
    return split(system(cmd), "\n")
  endif
endfunction


let python = 'python2'
let pydoc = 'pydoc2'

" some defaults
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
set fdm=indent
set foldlevel=30
set hlsearch
nnoremap <leader>/ :noh<cr>
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <leader>m :only<CR>
inoremap jj <ESC>

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Right_Window = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
if has('gui_running')
    colorscheme  desert
else
    colorscheme  evening
endif


" save root files while not root
cmap w!! w !sudo tee % >/dev/null
