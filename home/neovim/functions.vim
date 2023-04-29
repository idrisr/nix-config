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
