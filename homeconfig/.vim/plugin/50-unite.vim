" Unite settings
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
	\ ['git', 'ls-files', '-co', '--exclude-standard'])
nnoremap <leader>f :<C-u>Denite
                \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
nnoremap <silent><C-p> :<C-u>Denite
                \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
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
