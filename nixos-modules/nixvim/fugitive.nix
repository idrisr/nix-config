{
  config.programs.nixvim = {
    plugins.fugitive = { enable = true; };
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
      {
        key = "<leader>f";
        action = '':Git show --follow --pretty=" " --name-only <cword><cr>'';
        mode = "n";
      }
    ];
  };
}

# autocmd! User FugitiveCommit execute 'Git log -n1 --stat ' . expand('%:t')
