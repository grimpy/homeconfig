let NERDTreeQuitOnOpen = 1
let NERDTreeShowBookmarks = 1
let NERDTreeChDirMode = 2
let NERDTreeBookmarksSort = 0
let NERDTreeMinimalUI = 1
let NERDTreeIgnore = ['.*\.pyc$']
let g:NERDTreeUseTCD = 1

nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTreeToggle<CR>
nnoremap <F2> :NERDTreeToggle<CR>
let g:NERDTreeLimitedSyntax = 1 " limit syntax for the most popular extensions
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:NERDTreeDirArrowExpandable = '🖿'
let g:NERDTreeDirArrowCollapsible = ''
