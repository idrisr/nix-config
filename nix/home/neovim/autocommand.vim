augroup awk
    autocmd!
    autocmd BufNewFile,BufRead *.awk setlocal makeprg=awk\ -f\ %\ $*
augroup end

augroup bash
    autocmd!
    autocmd BufNewFile,BufRead *.sh setlocal makeprg=bash\ -f\ %\ $*
augroup end

augroup css
    autocmd!
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
augroup end

augroup cursor
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup end

augroup Dockerfile
    autocmd!
    autocmd Filetype Dockerfile setlocal colorcolumn=81
    autocmd WinLeave * setlocal nocursorline
augroup end

augroup haskell
    autocmd!
    autocmd! Filetype haskell setlocal foldlevel=99
augroup end

augroup help
    autocmd!
    autocmd! Filetype help setlocal number buflisted
augroup end

augroup java
    autocmd!
    autocmd BufNewFile,BufRead *.java setlocal makeprg=java\ %
augroup end

augroup jinja
    autocmd!
    autocmd BufNewFile,BufRead *.j2 setlocal filetype=jinja
    autocmd BufNewFile,BufRead *.tpl setlocal filetype=jinja
augroup end

augroup nix
    autocmd!
    autocmd Filetype nix setlocal makeprg=nix\ eval\ -f\ %
    autocmd! Filetype nix setlocal foldlevel=4
augroup end

augroup jq
    autocmd!
    autocmd BufNewFile,BufRead *.jq setlocal makeprg=jq\ -f\ %\ $*
augroup end

augroup zettel
    autocmd!
    autocmd BufNewFile,BufRead ~/roam-export/*.md setlocal filetype=zettel
    autocmd Filetype zettel setlocal colorcolumn=81
    autocmd Filetype zettel :CocDisable
    autocmd Filetype zettel setlocal foldmethod=expr
    autocmd Filetype zettel setlocal foldexpr=GetZettelFold(v:lnum)
    autocmd Filetype zettel setlocal syntax=0 dictionary+=/usr/share/dict/words complete+=k
    autocmd Filetype zettel setlocal foldlevelstart=2
    autocmd Filetype zettel setlocal spelllang=en_us
    autocmd Filetype zettel setlocal spellfile=~/roam-export/spellfile.add
augroup end

augroup perl
    autocmd!
    autocmd FileType perl setlocal makeprg=perl\ %\ $*
    autocmd FileType perl setlocal efm=%m\ at\ %f\ line\ %l.
    autocmd FileType perl nnoremap <buffer> <leader>m :w<cr>:make<cr><cr>:copen<cr><c-w><c-w>
    autocmd FileType perl vnoremap <buffer> <leader>m :w<cr>:make<cr><cr>:copen<cr><c-w><c-w>
augroup end

augroup sed
    autocmd!
    autocmd BufNewFile,BufRead *.sed setlocal makeprg=sed\ -f\ %\ $*
    autocmd BufNewFile,BufRead *.sed setlocal efm=sed:\ file\ %f\ line\ %l:%m
augroup end

augroup tex
    autocmd!
    autocmd filetype tex setlocal makeprg=lualatex\ -shell-escape\ %\ $*
    autocmd filetype tex setlocal foldmethod=marker
    autocmd FileType tex nnoremap <buffer> <leader>m :w<cr>:make<cr><cr>:copen<cr><c-w><c-w>
    autocmd FileType tex nnoremap <buffer> <leader>p :LLPStartPreview<cr>
augroup end

augroup tmux
    autocmd!
    autocmd FileType tmux setlocal foldmethod=marker
augroup end

augroup vim
    autocmd!
    autocmd Filetype vim nnoremap <buffer> <leader>m :w<cr>:source %<cr>
augroup end

augroup vimrc
    autocmd!
    autocmd BufNewFile,BufRead $HOME/.vimrc setlocal foldmethod=marker
    autocmd BufNewFile,BufRead $HOME/dotfiles/vim/vimrc setlocal foldmethod=marker
augroup end

augroup yaml
    autocmd!
    autocmd BufNewFile,BufRead yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup end

augroup zsh
    autocmd!
    autocmd BufNewFile,BufRead *.zsh-theme setlocal filetype=sh
augroup end
