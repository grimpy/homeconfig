command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nnoremap <silent><C-p>f :call fzf#vim#files(0, fzf#vim#with_preview(), 1)<cr>
nnoremap <C-p>g :Rg! 
nnoremap <silent><C-p>b :Buffers<cr>
nnoremap <silent><C-p>c :Commits<cr>
nnoremap <silent><C-p>h :BCommits<cr>
nnoremap <leader>y :Denite history/yank<cr>
