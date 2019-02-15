" Plugin config
let g:jedi#popup_on_dot = 1
let g:jedi#usages_command = "<leader>u"
let g:jedi#use_tabs_not_buffers = 0

let python_highlight_all = 1
let python_version_2 = 0

let g:notes_directories = ['~/Documents/Notes']
let g:notes_suffix = '.txt'
let g:xmledit_enable_html = 1

let g:airline_powerline_fonts = 1

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Right_Window = 1
let g:gh_open_command = 'xdg-open '
let g:gh_gitlab_domain = "git.gig.tech"
let g:gh_use_canonical = 0

" Plugin keymaps
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest end<CR>
nmap <silent><Leader>ts <Esc>:Pytest session<CR>
