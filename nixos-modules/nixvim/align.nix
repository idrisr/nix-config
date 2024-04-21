{ pkgs, ... }: {
  config.programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.vim-easy-align ];
    keymaps = [{
      key = "<leader>na";
      action = ":EasyAlign -1 /\\v\\s+[0-9]+$/<cr>";
      mode = "v";
      options = { desc = "align last number of each line in selection"; };
    }];
  };
}

# vnoremap <leader>na :EasyAlign -1 /\v\s+[0-9]+$/<cr>
# " Start interactive EasyAlign in visual mode (e.g. vipga)
# xmap ga <Plug>(EasyAlign)
# " Start interactive EasyAlign for a motion/text object (e.g. gaip)
# nmap ga <Plug>(EasyAlign)
