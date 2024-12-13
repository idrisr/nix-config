{
  config = {
    programs.nixvim = {
      keymaps = [
        # move to filetype only for zettel
        {
          key = "<C-Up>";
          action = ":resize +2<CR>";
          mode = "n";
          options = { desc = "resize up"; };
        }
        {
          key = "<C-Down>";
          action = ":resize -2<CR>";
          mode = "n";
          options = { desc = "resize down"; };
        }
        {
          key = "<C-Left>";
          action = ":vertical resize +2<CR>";
          mode = "n";
          options = { desc = "resize left"; };
        }
        {
          key = "<C-Right>";
          action = ":vertical resize -2<CR>";
          mode = "n";
          options = { desc = "resize right"; };
        }

        {
          key = "<leader>sp";
          action = ":split<cr>";
          mode = "n";
          options = { desc = "horizontal split"; };
        }
        {
          key = "<leader>8";
          action = ":set textwidth=80<CR>";
          mode = "n";
          options = { desc = "set textwidth to 80"; };
        }
        {
          key = "<leader>vsp";
          action = ":vsplit<cr>";
          mode = "n";
          options = { desc = "vertical split"; };
        }
        {
          key = "<leader>la";
          action = ":lua= vim.lsp.buf.code_action()<CR>";
          mode = "n";
          options = { desc = "lsp code actions"; };
        }
        {
          key = "<leader>lt";
          action = '':lua= require("lsp_lines").toggle()<CR>'';
          mode = "n";
          options = { desc = "toggle lsp lines"; };
        }
        {
          action = ":set hlsearch!<cr>";
          key = "<c-h><c-h>";
          mode = "n";
        }
        {
          key = "<c-n><c-n>";
          action = ":set number!<cr>";
          mode = "n";
        }
        {
          action = "dd<esc>";
          key = "dd";
          mode = "n";
        }
        {
          key = "<leader>ss";
          action = ":set spell!<cr>";
          mode = "n";
        }
        {
          key = "<leader>q";
          action = ":q <CR>";
          mode = "n";
        }
        {
          key = "<leader>w";
          action = ":w <CR>";
          mode = "n";
        }
        {
          key = "/";
          action = "/\\v";
          mode = "n";
        }
      ];
    };
  };
}
