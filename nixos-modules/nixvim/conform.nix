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
      formattersByFt = {
        tex = [ "latexindent" ];
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
        bib = [ "bibtex-tidy" ];
        terraform = [ "terraform_fmt" ];
        "*" = [ "trim_newlines" "trim_whitespace" "codespell" ];
      };
    };
  };
}
