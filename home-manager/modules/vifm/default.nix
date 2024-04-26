{ pkgs, lib, ... }: {
  config = {
    programs.vifm = {
      viewer = pkgs.writeShellApplication {
        name = "YO";
        runtimeInputs = [ ];
        text = "";
      };
      enable = true;
      marks = {
        b = "~/books";
        d = "~/documents";
        h = "~/";
        m = "~/fun/memorandum";
        n = "~/dotfiles";
        p = "~/documents/papers";
        r = "~/roam-export";
        s = "~/screenshots";
        v = "~/videos";
        w = "~/downloads";
        W = "~/wallpapers";
      };
      extraConfig = lib.concatStringsSep "\n" [
        (builtins.readFile ./vifmrc)
        (builtins.readFile ./favicons.vifm)
        (builtins.readFile ./vifm-colors/gruvbox.vifm)
      ];
      opts = {
        viewcolumns = "-80%{name}";
        history = 100;
        ignorecase = true;
        incsearch = true;
        nofollowlinks = true;
        nohlsearch = true;
        number = true;
        norunexec = true;
        scrolloff = 4;
        smartcase = true;
        sortnumbers = true;
        statusline =
          ''"%1* %-10t %2* owner:%u:%-7g %5* size:%s %N %3* attr:%A 4* %20d "'';
        suggestoptions = "normal,visual,view,otherpane,keys,marks,registers";
        syscalls = true;
        timefmt = ''"%m/%d %H:%M"'';
        trash = true;
        undolevels = 100;
        vicmd = "vim";
        vimhelp = true;
        wildmenu = true;
        wildstyle = "popup";
      };
    };
    home.packages = with pkgs; [ libheif ];
  };
}
