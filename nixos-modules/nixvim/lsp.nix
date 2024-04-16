{
  config.programs.nixvim.plugins = {
    lsp.keymaps.diagnostic = {
      "<leader>j" = "goto_next";
      "<leader>k" = "goto_prev";
    };

    lsp.keymaps.lspBuf = {
      K = "hover";
      gD = "references";
      gd = "definition";
      gi = "implementation";
      gt = "type_definition";
    };
  };
}
