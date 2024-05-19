{
  config.programs.nixvim = {
    plugins.treesitter.enable = true;
    plugins.telescope = {
      extensions = {
        media-files.enable = true;
        ui-select.enable = true;
        file-browser.enable = true;
      };
      enable = true;
      keymaps = {

        "<leader>tx" = {
          action = "find_files";
          options = {
            desc = "tele files";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tz" = {
          action = "git_files";
          options = {
            desc = "tele git files";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tb" = {
          action = "buffers";
          options = {
            desc = "tele buffers";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tg" = {
          action = "grep_string";
          options = {
            desc = "tele grep current word";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tr" = {
          action = "live_grep";
          options = {
            desc = "tele grep live word";
            silent = true;
          };
          mode = "n";
        };
      };

      settings = {
        defaults = {
          file_ignore_patterns = [ "^.git/" ];
          layout_config = {
            prompt_position = "bottom";
            horizontal = {
              width = 0.98;
              height = 0.98;
            };
          };
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
  };
}
