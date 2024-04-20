{
  config = {
    programs.nixvim = {
      keymaps = [
        {
          key = "<leader>sp";
          action = ":split";
          mode = "n";
        }
        {
          key = "<leader>vsp";
          action = ":vsplit";
          mode = "n";
        }
        {
          key = "<leader>b";
          action = ":Telescope buffers<cr>";
          mode = "n";
        }
      ];
      globals = {
        maplocalleader = ",";
        mapleader = ";";
      };
      opts = {
        autochdir = false;
        autoindent = true;
        expandtab = true;
        exrc = true;
        foldmethod = "indent";
        foldlevel = 99;
        ignorecase = true;
        incsearch = true;
        laststatus = 2;
        hlsearch = false;
        number = true;
        numberwidth = 2;
        relativenumber = false;
        ruler = true;
        secure = true;
        shiftwidth = 4;
        smartcase = true;
        softtabstop = 4;
        splitright = true;
        tabstop = 4;
        textwidth = 80;
        timeoutlen = 1000;
        wrap = true;
      };
    };
  };
}
