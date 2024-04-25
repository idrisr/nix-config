{
  config.programs.nixvim.plugins = {
    lspsaga = {
      enable = true;
      outline.winWidth = 40;
      lightbulb.sign = false;
    };
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        hls.enable = true;
        lua-ls.enable = true;
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
