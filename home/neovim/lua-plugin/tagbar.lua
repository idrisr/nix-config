vim.g.tagbar_autoclose=0
vim.api.nvim_set_keymap('n', '<leader>tb', ':TagbarToggle<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>tp', ':TagbarTogglePause<CR>', { silent = true })

vim.g.tagbar_type_tf = {
  ctagstype = 'terraform',
  kinds = {
    'r:Resource',
    'R:Resource',
    'd:Data',
    'D:Data',
    'v:Variable',
    'V:Variable',
    'p:Provider',
    'P:Provider',
    'm:Module',
    'M:Module',
    'o:Output',
    'O:Output',
    'f:TFVar',
    'F:TFVar'
  },
  sort=0
}

vim.g.tagbar_type_zettel = {
    ctagstype = 'zettel',
    kinds = {
    's:Section',
    'l:Link'
    },
    sort = 0
}

vim.g.tagbar_type_make = {
    kinds = {
    'm:macros',
    't:targets'
    },
    sort = 0
}

vim.g.tagbar_type_systemd = {
    ctagstype = 'SystemdUnit',
    kinds = {
        't:Type',
        'u:Unit',
        's:Service'
    }
}

vim.g.tagbar_type_lhaskell = {
    ctagsbin = 'hasktags',
    ctagsargs = '-x -c -o-',
    kinds = {
        'm:modules:0:1',
        'd:data:0:1',
        'd_gadt:data gadt:0:1',
        't:type names:0:1',
        'nt:new types:0:1',
        'c:classes:0:1',
        'cons:constructors:1:1',
        'c_gadt:constructor gadt:1:1',
        'c_a:constructor accessors:1:1',
        'ft:function types:1:1',
        'fi:function implementations:0:1',
        'i:instance:0:1',
        'o:others:0:1'
    },
    sro = '.',
    kind2scope = {
        m = 'module',
        c = 'class',
        d = 'data',
        t = 'type',
        i = 'instance'
    },
    scope2kind = {
        module = 'm',
        class = 'c',
        data = 'd',
        type = 't',
        instance = 'i'
    }
}

vim.g.tagbar_type_json = {
    ctagstype = 'json',
    kinds = {
        'o:objects',
        'a:arrays',
        'n:numbers',
        's:strings',
        'b:booleans',
        'z:nulls'
    },
    sro = '.',
    scope2kind = {
        object = 'o',
        array = 'a',
        number = 'n',
        string = 's',
        boolean = 'b',
        null = 'z'
    },
    kind2scope = {
        o = 'object',
        a = 'array',
        n = 'number',
        s = 'string',
        b = 'boolean',
        z = 'null'
    },
    sort = 0
}

vim.g.tagbar_type_ansible = {
    ctagstype = 'ansible',
    kinds = {
        't:tasks'
    },
    sort = 0
}

vim.g.tagbar_type_yaml = {
    ctagstype = 'AnsiblePlaybook',
    kinds = {
        'p:plays'
    },
    sort = 0
}
