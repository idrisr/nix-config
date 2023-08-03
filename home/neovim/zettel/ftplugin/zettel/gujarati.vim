" https://github.com/j0057/vim-fzfunicode/blob/master/autoload/fzfu.vim
function! Fzfu_Select()
    let names_list = '/home/hippoid/.config/fzf-unicode/NamesList.txt'
    let lines = fzf#run({'source': "gawk 'BEGIN{FS=\"\\t\"}
                       \                  /^[0-9A-F]+/{chr=strtonum(\"0x\" $1); printf(\"%08x — U+%04X — %s\\n\", chr, chr, $2)}
                       \                  /^\\t=/{printf \"%08x — U+%04X — %s\\n\", chr, chr, $2}'
                       \                  " .. names_list,
                       \ 'options': ['--delimiter', ' — ',
                       \             '--with-nth', '2..',
                       \             '--preview', 'for c in {+1}; do echo -en "\U$c"; done',
                       \             '--preview-window', 'down,1',
                       \             '--multi',
                       \             '--bind', 'tab:toggle',
                       \             '--bind', 'btab:toggle'],
                       \ 'sink': function('PInsert')})
    return lines
endfunction

nnoremap <leader>G :call Fzfu_Select()<cr>

function! PInsert(lines)
    let unicode = matchstr(a:lines, 'U+\x\{4}')
    let slicedString = strpart(unicode, 2)
    call feedkeys("i\<C-V>u" . slicedString . "\<CR>", 'n')
endfunction

function! TryUnicodeEntry(char)
    " let unicode = "U0AA4"
    call feedkeys("i\<C-V>u" . a:char . "\<CR>", 'n')
endfunction

command! Fg call Fzfu_FzfUnicodeName()
function! Fzfu_FzfUnicodeChar()
    let lines = Fzfu_Select()
    let codepoints =  map(copy(lines), {i, line -> eval(printf('"\U%08X"', str2nr(split(line)[0], 16)))})
    return join(codepoints, '')
endfunction

function! Fzfu_FzfUnicodeName()
    let lines = Fzfu_Select()
    let names = map(copy(lines), {i, line -> join(split(line, ' — ')[1:], ' ')})
    return join(names, "\n")
endfunction
