{
  config = {
    programs.nixvim = {
      keymaps = [
        {
          key = "<leader>sp";
          action = ":split<cr>";
          mode = "n";
          options = { desc = "horizontal split"; };
        }
        {
          key = "<leader>vsp";
          action = ":vsplit<cr>";
          mode = "n";
          options = { desc = "vertical split"; };
        }
        {
          key = "<leader>b";
          action = ":Telescope buffers<cr>";
          mode = "n";
          options = { desc = "buffer search"; };
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
