" Unite settings
let g:unite_source_history_yank_enable = 1
nnoremap <leader>f :Unite -no-split -buffer-name=files -profile-name=files -start-insert file_rec/async<cr>
nnoremap <leader>a :Unite -no-split -auto-preview grep:.<cr>
nnoremap <leader>b :Unite -no-split buffer:-<cr>
nnoremap <leader>y :Unite -no-split history/yank<cr>
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#profile('files', 'ignorecase', 1)
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
	" Overwrite settings.
    nnoremap <silent><buffer><expr> v unite#do_action('vsplit')
    inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
    nnoremap <silent><buffer><expr> p
        \ empty(filter(range(1, winnr('$')),
        \ 'getwinvar(v:val, "&previewwindow") != 0')) ?
        \ unite#do_action('preview') : ":\<C-u>pclose!\<CR>"
endfunction
