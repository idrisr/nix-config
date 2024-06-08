{ lib, ... }:
with lib; {
  config.programs.nixvim.plugins = {
    lspsaga.enable = false;
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        ccls.enable = true;
        cssls.enable = true;
        hls.enable = true;
        html.enable = true;
        idris.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        purescriptls.enable = true;
        pyright.enable = true;
        texlab.enable = true;
        tsserver.enable = true;
      };

      keymaps = {
        diagnostic = { "<space>q" = "setloclist"; };
        lspBuf = {
          K = "hover";
          "<leader>gr" = "references";
          "<leader>gd" = "definition";
          "<leader>gt" = "type_definition";
        };
      };
    };
  };
}
