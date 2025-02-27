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
                  "-output-directory=build"
                  "-aux-directory=build"
                  "-interaction=nonstopmode"
                  "-synctex=1"
                  "%f"
                ];
                executable = "latexmk";
                forwardSearchAfter = true;
                onSave = false;
                pdfDirectory = "build";
              };
              chktex = {
                onEdit = false;
                onOpenAndSave = false;
              };
              symbols.customEnvironments = [
                {
                  name = "definition";
                  displayName = "definition";
                }
                {
                  name = "example";
                  displayName = "example";
                }
                {
                  name = "intuition";
                  displayName = "intuition";
                }
                {
                  name = "exercise";
                  displayName = "exercise";
                }
                {
                  name = "haskell";
                  displayName = "haskell";
                }
              ];
              forwardSearch = {
                executable = "zathura";
                args = [ "--synctex-forward" "%l:1:%f" "%p" ];
              };
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
