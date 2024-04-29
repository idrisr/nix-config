{
  config.programs.nixvim = {
    plugins.gitsigns.enable = true;
    plugins.fugitive.enable = true;
    userCommands = {
      "Gb" = {
        bang = true;
        command = "Git blame --date relative";
        desc = "Show git history with relative dates";
      };
    };
    # " command! Gb Git blame --date=relative
    keymaps = [
      {
        key = "<leader>l";
        action = '':Git log --relative --pretty=format:"%h %as %ar %s" %<cr>'';
        mode = "n";
      }
      {
        key = "<leader>L";
        action = ":tab Git log --follow -p %<cr>";
        mode = "n";
      }
    ];
  };
}

# autocmd! User FugitiveCommit execute 'Git log -n1 --stat ' . expand('%:t')
