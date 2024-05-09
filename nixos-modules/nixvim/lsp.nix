{
  config.programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        hls.enable = true;
        lua-ls.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        texlab.enable = true;
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
