let g:ale_set_highlights=0
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
\   'ansible': ['ansible-lint'],
\   'c': ['clangtidy'],
\   'css': ['csslint'],
\   'Dockerfile': ['hadolint'],
\   'html': ['tidy'],
\   'markdown': ['markdownlint'],
\   'json': ['jq'],
\   'sh': ['shellcheck'],
\   'yaml': ['yamllint'],
\}

" use a map to add default?
let s:default = ['trim_whitespace', 'remove_trailing_lines']
let g:ale_fixers = {
\   '*': s:default,
\   'css': ['prettier'],
\   'html': ['tidy'],
\   'nix': ['nixfmt'] + s:default,
\   'lua': ['stylua'],
\   'json': ['jq'],
\   'sh': ['shfmt'] + s:default,
\   'sql': ['sqlformat'],
\   'terraform': ['terraform'],
\   'tex': ['latexindent',  'textlint' ],
\   'text': [],
\   'yaml': ['yamlfix'],
\}

let g:ale_sql_sqlformat_options='--wrap_after 80 -k upper -r -s'
let g:ale_dockerfile_hadolint_use_docker='never'
let g:ale_disable_lsp=1
