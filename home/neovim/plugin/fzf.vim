let g:fzf_preview_window = ['up:70%', 'ctrl-/']
nnoremap <leader>z :GFiles<CR>
nnoremap <leader>x :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>d :Windows<CR>
nnoremap <leader>r :Rg<CR>
nnoremap <leader>k :Ki<CR>
nnoremap <leader>K :YO<CR>
nnoremap <leader>nx :e gtd\ projects.md<CR> :NX next action<CR>
nnoremap <leader>G :edit gtd\ projects.md<CR>
nnoremap <leader>D :edit dailys.md<CR>

let g:fzf_layout = { 'window': 'enew' }
let g:fzf_buffers_jump = 0
let g:fzf_tags_command = 'ctags -R'

 let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-b': ':bd' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

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


let g:rg_string='rg -r ' . "'$1' " . '--only-matching --no-line-number --no-filename "\[\[(.+?)\]\]" '

" TODO: make a func to DRY
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
