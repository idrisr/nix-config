{
  config = {
    programs.nixvim = {
      autoCmd = [{
        event = [ "BufEnter" ];
        pattern = [ "*.tex" ];
        command = ":setlocal textwidth=0";
      }

        ];
      keymaps = [
        # move to filetype only for zettel
        {
          key = "<leader>k";
          action = ":LinksOut<cr>";
          mode = "n";
          options = {
            desc = "zettel out links";
            silent = true;
          };
        }
        {
          key = "<leader>K";
          action = ":LinksIn<cr>";
          mode = "n";
          options = {
            desc = "zettel in links";
            silent = true;
          };
        }
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
