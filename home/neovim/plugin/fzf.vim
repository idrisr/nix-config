nnoremap <leader>g  :set operatorfunc=<SID>GrepOperator<cr>g@
nnoremap <leader>gt :set operatorfunc=<SID>GrepOperator<cr>g@i[
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
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

command! -bang -nargs=* LL call
    \ fzf#run({'source': 'rg --only-matching --no-line-number --no-filename "\[\[(.+)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| tr -d "[]" | awk ' . "'" . '{print $0".md"}' . "'"
    \, 'options': '--preview "bat {}"'
    \, 'right':  '50%'
    \, 'sink':  'e' })

command! -bang -nargs=* NN call
    \ fzf#vim#grep('rg -r ' . "'$1' " . '--only-matching --no-filename "\[\[(.+?)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| sort -ur'
    \ . '| awk ' . "'" . '{print $0".md"}' . "'"
    \ . '| tr "\n" "\0" '
    \ . '| xargs -0 rg --column --line-number --no-heading ' . shellescape(<q-args>) . ' {}',
    \ 1,
    \ fzf#vim#with_preview( {'options': '--exact'} ),
    \ <bang>0)

command! -bang -nargs=* NX call
    \ fzf#vim#grep('rg -r ' . "'$1' " . '--only-matching --no-filename "\[\[(.+?)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| sort -ur'
    \ . '| awk ' . "'" . '{print $0".md"}' . "'"
    \ . '| tr "\n" "\0" '
    \ . '| xargs -0 rg --column --line-number --no-heading ' . '^' . shellescape(<q-args>) . ' {}',
    \ 1,
    \ fzf#vim#with_preview( {'options': '--exact'} ),
    \ <bang>0)

command! -bang -nargs=* Ki call
    \ fzf#vim#grep('rg -r ' . "'$1' " . '--only-matching --no-line-number --no-filename "\[\[(.+?)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| sort -ur '
    \ . '| awk ' . "'" . '{print $0".md:1"}' . "'",
    \ 0,
    \ fzf#vim#with_preview( {'options': '--tac --exact --delimiter : --with-nth 1'} ),
    \ <bang>0)

command! -bang -nargs=* YO call
    \ fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case '\\[\\["
    \ . expand('%:t:r')
    \ . "\\]\\]'",
    \ 1,
    \ fzf#vim#with_preview( {'options': '--delimiter : --nth 4..'} ),
    \ <bang>0)

command! -bang -nargs=* Rg call
    \ fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview( {'options': '--delimiter : --nth 4..'} ),
    \ <bang>0)

command! -bang -nargs=* Tg call
    \ fzf#vim#grep("rg --word-regexp --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview( {'options': '--delimiter : --nth 4..'} ),
    \ <bang>0)
