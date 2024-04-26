{
  config.programs.nixvim = {
    keymaps = [
      {
        key = "<leader>cd";
        action = ":lua require('cmp').setup.buffer { enabled = false }<cr>";
        mode = "n";
        options = { desc = "disable cmp"; };
      }
      {
        key = "<leader>ce";
        action = ":lua require('cmp').setup.buffer { enabled = true}<cr>";
        mode = "n";
        options = { desc = "enable cmp"; };
      }
    ];

    plugins = {
      cmp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
      cmp-nvim-ultisnips.enable = true;
      cmp-nvim-lsp.enable = true;
      friendly-snippets.enable = true;
    };
  };
}
