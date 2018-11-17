" Pasting
nnoremap  <leader>l mzgg=G`z<CR>
au InsertLeave * set nopaste
" Reload vimrc
nnoremap <leader>R :source $MYVIMRC<CR>

nnoremap <leader>/ :noh<cr>
nnoremap <leader>m :only<CR>
nnoremap <leader>t :terminal<CR>
let g:black_fast = 1
nnoremap <leader>p :Black<CR>
nnoremap <leader>s :! vimsync -t be-g8-4-master -f %<CR>
tnoremap <Esc> <C-\><C-n>

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
nmap <f5> :make<CR>
inoremap jj <ESC>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" save root files while not root
cmap w!! w !sudo tee % >/dev/null

" Reselect visual blockafter indent/outdent
vnoremap < <gv
vnoremap > >gv

" I can type :help on my own, thanks.
noremap <F1> <Esc>
inoremap <F1> <Esc>

" aleternate last two buffers
noremap <Leader><Leader> <C-^>
"move lines with shit key
noremap J :m+<CR>
noremap K :m-2<CR>
vnoremap J :m'>+<CR>gv
vnoremap K :m-2<CR>gv

"home and end mappings
noremap H ^
noremap L $
vnoremap H ^
vnoremap L $

"easy command mode
nnoremap ; :
nnoremap <leader>h *<C-O>

" nuake
nnoremap <F3> :Nuake<CR>
inoremap <F3> <C-\><C-n>:Nuake<CR>
tnoremap <F3> <C-\><C-n>:Nuake<CR>
let g:nuake_per_tab = 1
