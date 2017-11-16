" Unite settings
nnoremap <leader>f :FZF<CR>
nnoremap <silent><C-p> :FZF<CR>
nnoremap <leader>a :Denite -auto-preview grep:.<cr>
nnoremap <leader>b :Denite buffer:-<cr>
nnoremap <leader>y :Denite history/yank<cr>
call denite#custom#map(
	      \ 'insert',
	      \ '<Down>',
	      \ '<denite:move_to_next_line>',
	      \ 'noremap'
	      \)
call denite#custom#map(
	      \ 'insert',
	      \ '<Up>',
	      \ '<denite:move_to_previous_line>',
	      \ 'noremap'
          \)
