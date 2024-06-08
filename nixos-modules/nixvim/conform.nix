{
  config.programs.nixvim.plugins = {
    lint = {
      enable = true;
      lintersByFt = { tex = [ "chktex" ]; };
      autoCmd = {
        callback = {
          __raw = ''
            function()
              require('lint').try_lint()
            end
          '';
        };
        event = "BufWritePost";
      };
    };
    conform-nvim = {
      enable = true;
      formatAfterSave = "true";
      notifyOnError = true;
      extraOptions = {
        quiet = false;
        async = true;
      };
      formattersByFt = {
        bib = [ "bibtex-tidy" ];
        c = [ "clang-format" ];
        cabal = [ "cabal_fmt" ];
        haskell = [ "fourmolu" ];
        html = [ "htmlbeautifier" ];
        javascript = [ "prettierd" ];
        jsonc = [ "fixjson" ];
        json = [ "fixjson" ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        purescript = [ "purescriptls" ];
        python = [ "isort" "black" ];
        terraform = [ "terraform_fmt" ];
        tex = [ "latexindent" ];
        text = [ ];
        typescript = [ "prettierd" ];
        "*" = [ "trim_newlines" "trim_whitespace" ];
      };
    };
  };
}
