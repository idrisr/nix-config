{
  config.programs.nixvim = {
    keymaps = [
      {
        key = "<leader>z";
        action = ":Telescope git_files<cr>";
        mode = "n";
      }
      {
        key = "<leader>x";
        action = ":Telescope find_files<cr>";
        mode = "n";
      }
      {
        key = "<leader>b";
        action = ":Telescope buffers<cr>";
        mode = "n";
      }
    ];
    plugins.telescope = {
      enable = true;
      settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];
          # layout_config = { prompt_position = "top"; };
          mappings = {
            i = {
              "<c-j>" = {
                __raw = "require('telescope.actions').move_selection_next";
              };
              "<c-k>" = {
                __raw = "require('telescope.actions').move_selection_previous";
              };
            };
          };
        };
      };
    };
    plugins.treesitter = { enable = true; };
  };
}
