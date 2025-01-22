{
  config.programs.nixvim.plugins = {
    lspsaga.enable = false;
    lsp-lines.enable = true;
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        ccls.enable = true;
        cssls.enable = true;
        hls = {
          enable = true;
          installGhc = false;
        };
        html.enable = true;
        # leanls.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        # ocamlls.enable = true;
        prolog_ls.enable = false;
        # purescriptls.enable = true;
        pyright.enable = true;
        texlab = {
          enable = true;
          settings = {
            texlab = {
              bibtexFormatter = "texlab";
              build = {
                args = [
                  "-file-line-error"
                  "-verbose"
                  "-shell-escape"
                  "-pdf"
                  "-interaction=nonstopmode"
                  "-synctex=1"
                  "%f"
                ];
                executable = "latexmk";
                forwardSearchAfter = false;
                onSave = true;
              };

              # options = [
              # "-synctex=1"
              # "-interaction=nonstopmode"
              # "-file-line-error"
              # "-verbose"
              # "-shell-escape"
              # ];
            };
          };
        };
      };

      keymaps = {
        diagnostic = { "<space>q" = "setloclist"; };
        lspBuf = {
          K = "hover";
          "<leader>gr" = "references";
          "<leader>gd" = "definition";
          "<leader>gt" = "type_definition";
          "<leader>ga" = "code_action";
        };
      };
    };
  };
}
