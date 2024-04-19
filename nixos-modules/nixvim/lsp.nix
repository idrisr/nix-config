{
  config.programs.nixvim.plugins = {
    lspsaga = {
      enable = true;
      outline.winWidth = 80;
      lightbulb.sign = false;
    };
    lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true;
        lua-ls.enable = true;
      };

      keymaps = {
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
          "<space>q" = "setloclist";
        };

        lspBuf = {
          K = "hover";
          "<leader>gr" = "references";
          "<leader>gd" = "definition";
          "<leader>gi" = "implementation";
          "<leader>gt" = "type_definition";
        };
      };
    };
  };
}
