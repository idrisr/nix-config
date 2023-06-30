augroup zettel
    autocmd!
    autocmd BufNewFile,BufRead ~/roam-export/*.md setlocal filetype=zettel
    autocmd Filetype zettel setlocal colorcolumn=81
    autocmd Filetype zettel setlocal foldmethod=expr
    autocmd Filetype zettel setlocal foldexpr=GetZettelFold(v:lnum)
    autocmd Filetype zettel setlocal syntax=0 dictionary+=/usr/share/dict/words complete+=k
    autocmd Filetype zettel setlocal foldlevelstart=2
    autocmd Filetype zettel setlocal spelllang=en_us
    autocmd Filetype zettel setlocal spellfile=~/roam-export/spellfile.add
    autocmd Filetype zettel :CocDisable
augroup end
