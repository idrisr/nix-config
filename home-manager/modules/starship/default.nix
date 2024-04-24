{
  config = {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = false;
        scan_timeout = 10;

        aws = { disabled = true; };

        character = {
          success_symbol = "➜";
          error_symbol = "➜";
        };

        directory = {
          truncation_length = 4;
          truncation_symbol = "…/";
          truncate_to_repo = false;
        };

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

        battery = {
          disabled = false;
          display = [
            {
              threshold = 10;
              style = "bold red";
              charging_symbol = "⚡️";
            }
            {
              threshold = 90;
              style = "bold yellow";
              discharging_symbol = "💦";
              charging_symbol = "⚡️";
            }
          ];

        };

        status = {
          disabled = false;
          symbol = "🔴 ";
          success_symbol = "🟢 ";
          format = "[$symbol$status]($style) ";
          map_symbol = true;
        };
      };
    };
  };
}
