{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.vim-easy-align ];
    keymaps = [
      {
        key = "<leader>na";
        action = ":EasyAlign -1 /\\v\\s+[0-9]+$/<cr>";
        mode = "v";
        options = { desc = "align last number of each line in selection"; };
      }
      {
        key = "ga";
        action = "<Plug>(EasyAlign)";
        mode = "x";
        options = {
          desc = "Start interactive EasyAlign in visual mode (e.g. vipga)";
        };
      }
    ];
  };
}

# " Start interactive EasyAlign for a motion/text object (e.g. gaip)
# nmap ga <Plug>(EasyAlign)
