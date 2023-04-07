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
