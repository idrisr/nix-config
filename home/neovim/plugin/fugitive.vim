nnoremap <leader>l :Git log --relative --pretty=format:"%h %as %ar %s" %<cr>
nnoremap <leader>L :tab Git log --follow -p %<cr>
nnoremap <leader>f :Git show --follow --pretty="" --name-only <cword><cr>
autocmd User FugitiveCommit execute 'Git log -n1 --stat ' . expand('%:t')
