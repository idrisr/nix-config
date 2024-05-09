{
  config.programs.nixvim.plugins.fzf-lua = {
    enable = false;
    profile = "fzf-vim";
    settings = {
      files = {
        color_icons = true;
        file_icons = true;
        find_opts = {
          __raw = "[[-type f -not -path '*.git/objects*' -not -path '*.env*']]";
        };
        multiprocess = true;
        prompt = "Files❯ ";
      };

      winopts = {
        col = 0.3;
        height = 0.93;
        row = 0.99;
        width = 0.93;
        preview.hidden = "nohidden";
      };
    };

    keymaps = {
      "<leader>zx" = {
        action = "files";
        options = {
          desc = "fzf-lua files";
          silent = true;
        };
        mode = "n";
      };
      "<leader>zz" = {
        action = "git_files";
        options = {
          desc = "fzf-lua git files";
          silent = true;
        };
        mode = "n";
      };
      "<leader>zb" = {
        action = "buffers";
        options = {
          desc = "fzf-lua buffers";
          silent = true;
        };
        mode = "n";
      };
      "<leader>zg" = {
        action = "grep_cWORD";
        options = {
          desc = "fzf-lua grep current word";
          silent = true;
        };
        mode = "n";
      };
    };
  };
}
