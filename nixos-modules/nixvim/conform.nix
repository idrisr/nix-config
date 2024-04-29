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
        "*" = [ "trim_whitespace" "codespell" ];
      };
    };
  };
}