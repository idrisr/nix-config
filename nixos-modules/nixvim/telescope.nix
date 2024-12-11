{
  config.programs.nixvim = {
    # plugins.treesitter.enable = true;
    plugins.web-devicons.enable = true;
    plugins.telescope = {
      extensions = {
        ui-select.enable = true;
        file-browser.enable = true;
      };
      enable = true;
      # lsp_type_definitions

      keymaps = {
        "<leader>ta" = {
          action = "lsp_definitions";
          options = {
            desc = "🎸 lsp definitions";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tb" = {
          action = "lsp_dynamic_workspace_symbols";
          options = {
            desc = "🎸 lsp dynamic workspace symbols";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tc" = {
          action = "lsp_document_symbols";
          options = {
            desc = "🎸 lsp document symbols";
            silent = true;
          };
          mode = "n";
        };
        "<leader>td" = {
          action = "lsp_definitions";
          options = {
            desc = "🎸 lsp definitions";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tr" = {
          action = "lsp_references";
          options = {
            desc = "🎸 lsp references";
            silent = true;
          };
          mode = "n";
        };

        "<leader>ti" = {
          action = "lsp_incoming_calls";
          options = {
            desc = "🎸 lsp incoming";
            silent = true;
          };
          mode = "n";
        };

        "<leader>to" = {
          action = "lsp_outgoing_calls";
          options = {
            desc = "🎸 lsp outgoing";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tx" = {
          action = "find_files";
          options = {
            desc = "🎸 files";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tz" = {
          action = "git_files";
          options = {
            desc = "🎸 git files";
            silent = true;
          };
          mode = "n";
        };

        "<leader>tg" = {
          action = "grep_string";
          options = {
            desc = "🎸 grep current word";
            silent = true;
          };
          mode = "n";
        };

        "<leader>te" = {
          action = "live_grep";
          options = {
            desc = "🎸 grep live word";
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
