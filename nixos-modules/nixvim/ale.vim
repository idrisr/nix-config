let g:ale_set_highlights=0
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'c': ['clangtidy'],
\   'css': ['csslint'],
\   'html': ['tidy'],
\   'markdown': ['markdownlint'],
\   'json': ['jq'],
\   'sh': ['shellcheck'],
\   'tex': ['chktex'],
\   'yaml': ['yamllint'],
\}

" use a map to add default?
let s:default = ['trim_whitespace', 'remove_trailing_lines']
let g:ale_fixers = {
\   'css': ['prettier'],
\   'html': ['tidy'],
\   'nix': ['nixfmt'] + s:default,
\   'lua': ['stylua'] + s:default,
\   'json': ['jq'],
\   'pdf': [],
\   'sh': ['shfmt', 'beautysh'] + s:default,
\   'sql': ['sqlformat'],
\   'terraform': ['terraform'] + s:default,
\   'tex': ['latexindent'] + s:default,
\   'tf': ['terraform'] + s:default,
\   'text': [],
\   'yaml': ['yamlfix'],
\   '*': s:default,
\}

let g:ale_sql_sqlformat_options='--wrap_after 80 -k upper -r -s'
let g:ale_disable_lsp=1
