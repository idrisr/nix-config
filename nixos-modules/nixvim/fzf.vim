nnoremap <leader>g  :set operatorfunc=GrepOperator<cr>g@
nnoremap <leader>gt :set operatorfunc=GrepOperator<cr>g@i[
vnoremap <leader>g :<c-u>call GrepOperator(visualmode())<cr>

function! g:GrepOperator(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    silent execute "Rg " . @@
    let @@ = saved_unnamed_register
endfunction
