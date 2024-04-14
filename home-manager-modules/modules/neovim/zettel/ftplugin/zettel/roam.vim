function! GetZettelFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return IndentLevel(a:lnum-1)
    endif

    let this_indent = IndentLevel(a:lnum)
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>'. next_indent
    endif
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif
        let current += 1
    endwhile

    return -2
endfunction

noremap <leader>vl :call ToggleVerticalLine()<cr>
function! ToggleVerticalLine()
    if &colorcolumn
        setlocal colorcolumn=0
    else
        setlocal colorcolumn=81
    endif
endfunction

function! s:ShowHelp(tag) abort
  if winheight('%') < winwidth('%')
    execute 'vertical botright help '.a:tag
    execute 'vertical resize 84'
    set relativenumber
  else
    execute 'help '.a:tag
  endif
endfunction
command! -nargs=1 H call s:ShowHelp(<f-args>)

let g:fzf_vim = {}

command! -bang -nargs=* ContentsOfLinks call
    \ fzf#vim#grep('rg --replace ' . "'$1' " . '--ignore-case --only-matching --no-filename "\[\[(.+?)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| sort -ur'
    \ . '| awk ' . "'" . '{print $0".md"}' . "'"
    \ . '| tr "\n" "\0" '
    \ . '| xargs -0 rg --column --ignore-case --line-number --no-heading ' . shellescape(<q-args>) . ' {}',
    \ 1,
    \ fzf#vim#with_preview( {'options': '--exact'} ),
    \ <bang>0)

command! -bang -nargs=* LinksOut call
    \ fzf#vim#grep('rg -r ' . "'$1' " . '--ignore-case --only-matching --no-line-number --no-filename "\[\[(.+?)\]\]" '
    \ . shellescape(expand('%:p'))
    \ . '| sort -ur '
    \ . '| awk ' . "'" . '{print $0".md:1"}' . "'",
    \ 0,
    \ fzf#vim#with_preview( {'options': '--tac --exact --delimiter : --with-nth 1'} ),
    \ <bang>0)

command! -bang -nargs=* LinksIn call
    \ fzf#vim#grep("rg --ignore-case --column --line-number --no-heading --color=always '\\[\\["
    \ . expand('%:t:r')
    \ . "\\]\\]'",
    \ 1,
    \ fzf#vim#with_preview( {'options': '--delimiter : --nth 4..'} ),
    \ <bang>0)

command! -bang -nargs=* Rg call
    \ fzf#vim#grep("rg --ignore-case --column --line-number --no-heading --color=always ".shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview( {'options': '--exact --delimiter : --nth 4..'} ),
    \ <bang>0)

command! -bang -nargs=* Tg call
    \ fzf#vim#grep("rg --ignore-case --word-regexp --column --line-number --no-heading --color=always ".shellescape(<q-args>),
    \ 1,
    \ fzf#vim#with_preview( {'options': '--delimiter : --nth 4..'} ),
    \ <bang>0)
