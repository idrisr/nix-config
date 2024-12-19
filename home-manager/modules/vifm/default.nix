{ pkgs, lib, ... }: {
  config = {
    programs.vifm = {
      enable = true;

      extraConfig = lib.concatStringsSep "\n" [
        (builtins.readFile ./vifmrc)
        (builtins.readFile ./favicons.vifm)
        ''
          set ignorecase
          set number
          set incsearch
          set sortnumbers
          mark b ~/books
          mark d ~/documents
          mark p ~/documents/papers
          mark s ~/screenshots
          mark t ~/documents/tech-talks
          mark v ~/videos
          mark w ~/downloads''
      ];

      opts = {
        viewcolumns = "-80%{name}";
        history = 100;
        ignorecase = true;
        nofollowlinks = true;
        nohlsearch = true;
        norunexec = true;
        scrolloff = 4;
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
        # wildstyle = "popup";
      };
    };
    home.packages = with pkgs; [ visualpreview libheif nix-derivation ];
  };
}
