" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" 
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" let g:deoplete#enable_at_startup = 1
" 
" " Plugin key-mappings.
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" xmap <C-k>     <Plug>(neosnippet_expand_target)
" 
" let g:neosnippet#snippets_directory='~/.vim/snippets'
" " SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"             \ "\<Plug>(neosnippet_expand_or_jump)"
"             \: pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"             \ "\<Plug>(neosnippet_expand_or_jump)"
"             \: "\<TAB>"
" 
" imap <C-Space> <C-x><C-o>
" imap <C-@> <C-Space>
"
set shortmess+=c
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
let g:jedi#completions_enabled = 0
let g:jedi#documentation_command = ""
let g:jedi#goto_command = "gd"
let g:jedi#usages_command = "gu"
