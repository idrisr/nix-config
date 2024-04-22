{ pkgs, lib, ... }:
let configSubDir = "vifm";
in {
  config = {
    programs.vifm = {
      enable = true;
      marks = {
        b = "~/books";
        d = "~/documents";
        h = "~/";
        m = "~/fun/memorandum";
        p = "~/documents/papers";
        r = "~/roam-export";
        s = "~/screenshots";
        v = "~/videos";
        w = "~/downloads";
      };
      extraConfig = lib.concatStringsSep "\n" [
        (builtins.readFile ./vifmrc)
        (builtins.readFile ./favicons.vifm)
      ];
      opts = {
        history = 100;
        ignorecase = true;
        incsearch = true;
        nofollowlinks = true;
        nohlsearch = true;
        norunexec = true;
        scrolloff = 4;
        smartcase = true;
        sortnumbers = true;
        statusline = ''"  Hint: %z%= %A %10u:%-7g %15s %20d  "'';
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
    xdg.configFile = {
      "${configSubDir}/scripts/cleaner" = {
        text = builtins.readFile ./scripts/cleaner;
        executable = true;
      };
      "${configSubDir}/scripts/scope" = {
        text = builtins.readFile ./scripts/scope;
        executable = true;
      };
    };
    home.packages = with pkgs; [ libheif ];
  };
}
