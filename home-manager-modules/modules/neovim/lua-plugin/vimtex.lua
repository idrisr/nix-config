vim.g.vimtex_compiler_latexmk = {
    executable = 'latexmk',
    continuous= 1,
    callback=1,
    engine= "-pdf",
    viewer= "General",
    options = {
        -- '-outdir=build',
        '-synctex=1',
        '-interaction=nonstopmode',
        '-file-line-error',
        '-verbose',
        '-shell-escape'
    },
}

vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3;
vim.g.vimtex_quickfix_open_on_warning=0;
