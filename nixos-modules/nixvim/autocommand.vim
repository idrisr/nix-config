augroup bash
    autocmd!
    autocmd BufNewFile,BufRead *.sh setlocal makeprg=bash\ -f\ %\ $*
augroup end

augroup haskell
    autocmd!
    autocmd! Filetype haskell setlocal foldlevel=99
augroup end

augroup help
    autocmd!
    autocmd! Filetype help setlocal number buflisted
augroup end

augroup nix
    autocmd!
    autocmd Filetype nix setlocal makeprg=nix\ eval\ -f\ %
    autocmd Filetype nix setlocal foldlevel=4
augroup end
