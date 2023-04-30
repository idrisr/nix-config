{ lib, ... }: {
  config = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        scan_timeout = 10;
        character = {
          success_symbol = "➜";
          error_symbol = "➜";
        };

        directory = {
          truncation_length = 4;
          truncation_symbol = "…/";
        };

        aws = { disabled = true; };

        git_metrics = { disabled = false; };

        git_status = {
          conflicted = "🏳";
          ahead = "🏎💨";
          behind = "😰";
          diverged = "😵";
          up_to_date = "✓";
          untracked = "🤷";
          stashed = "📦";
          modified = "📝";
          staged = "[++($count)](green)";
          renamed = "👅";
          deleted = "🗑";
        };

        nix_shell = {
          disabled = false;
          format = " [$symbol$state]($style) ";
        };

        haskell = {
          disabled = false;
          format = " [$symbol($version )]($style)";
        };
      };
    };
  };
}
