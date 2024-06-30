{
  config = {
    programs.nixvim = {
      globals = {
        maplocalleader = ",";
        mapleader = ";";
      };
      opts = {
        autochdir = false;
        autoindent = true;
        compatible = false;
        cursorline = true;
        expandtab = true;
        exrc = true;
        foldmethod = "indent";
        foldlevel = 99;
        ignorecase = true;
        incsearch = true;
        laststatus = 2;
        list = false;
        hlsearch = false;
        number = true;
        numberwidth = 2;
        relativenumber = false;
        ruler = true;
        secure = true;
        shiftwidth = 4;
        signcolumn = "yes";
        smartcase = true;
        softtabstop = 4;
        showtabline = 2; # always show tabs
        spellcapcheck = "";
        splitright = true;
        splitbelow = true;
        tabstop = 4;
        termguicolors = true; # Enables 24-bit RGB color in the tui
        textwidth = 80;
        timeoutlen = 1000;
        wrap = true;
        writebackup =
          false; # if file is being written by another program, dont allow it to be edited
      };
    };
  };
}
