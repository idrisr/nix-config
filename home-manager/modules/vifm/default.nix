{ pkgs, lib, ... }:
let vp = "${pkgs.visualpreview}/bin/visualpreview";
in {
  config = {
    programs.vifm = {
      enable = true;

      # fileviewer <video/*> ${vp} video %pw %ph %px %py %c %N %pc ${vp} clear
      extraConfig = lib.concatStringsSep "\n" [
        (builtins.readFile ./favicons.vifm)
        ''
          if !has('win')
              set slowfs=curlftpfs
          endif

          set number
          set incsearch
          set sortnumbers
          set ignorecase

          mark b ~/books
          mark d ~/documents
          mark p ~/documents/papers
          mark s ~/screenshots
          mark t ~/documents/tech-talks
          mark v ~/videos
          mark w ~/downloads

          fileviewer */ ${pkgs.lsd}/bin/lsd --tree --depth 2 --almost-all --ignore-glob .git %c
          fileviewer {*.drv} ${pkgs.nix-derivation}/bin/pretty-derivation < %c
          fileviewer {*.epub,*.mobi,*.azw,*.azw[0-9]},<application/epub+zip>,<application/x-mobipocket-ebook>,<application/vnd.amazon.ebook> ${vp} epub %pw %ph %px %py %c %N %pc ${vp} clear
          fileviewer <font/*> ${vp} font %pw %ph %px %py %c %N %pc ${vp} clear
          fileviewer <image/*> ${vp} image %pw %ph %px %py %c %N %pc ${vp} clear
          fileviewer {*.pdf} ${vp} pdf %pw %ph %px %py %c %N %pc ${vp} clear, ${pkgs.poppler_utils}/bin/pdfinfo, ${pkgs.pdftc}/bin/pdftc
          fileviewer {*.srt} ${pkgs.srtcpy}/bin/srtcpy %f, bat %f
          fileviewer <video/*> mediainfo --Output=JSON %f | ${pkgs.videoChapter}/bin/videoChapter
          fileviewer {*.vtt} ${pkgs.vttclean}/bin/vttclean --file %c
          fileviewer {*.zip} ${pkgs.unzip}/bin/unzip -l
          fileviewer {*.mp3, *.m4a} ${pkgs.audioPreview}/bin/audioPreview
          fileviewer {*.iso} ${pkgs.cdrtools}/bin/isoinfo -i %f -d

          filextype *.docx,*.ods ${pkgs.libreoffice}/bin/libreoffice %c
          filextype <image/*> {View in sxiv} sxiv -ia %f &
          filextype *wav,*mp3,*mkv,*webm,*mp4,*mov,*avi,*m4v ${pkgs.mpv}/bin/mpv --force-window %f 2>/dev/null &
          filextype *.pdf,*.epub ${pkgs.zathura}/bin/zathura %c %i &, apvlv %c, xpdf %c
          filextype *.vv ${pkgs.virt-viewer}/bin/remote-viewer %c &
          filextype *.rnote ${pkgs.rnote}/bin/rnote %c &

          nnoremap w :view<cr>
          nnoremap L :!${pkgs.srtcpy}/bin/srtcpy %f | ${pkgs.xclip}/bin/xclip -selection clipboard <cr>
          nnoremap sv :source $MYVIFMRC<cr>
          nnoremap s :sort <cr>
          vnoremap w :view<cr>gv
          nnoremap ;q :q <CR>
          nnoremap I cW<c-a>
          nnoremap A cW<c-u>
          nnoremap pa vifm-q_a
          autocmd DirEnter /home/hippoid/screenshots set sort=+mtime
          autocmd DirEnter !/home/hippoid/screenshots set sort=+name
        ''
      ];

      opts = {
        history = 100;
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
        viewcolumns = "-80%{name}";
        vimhelp = true;
        wildmenu = true;
        # wildstyle = "popup";
      };
    };
    home.packages = with pkgs; [ visualpreview libheif nix-derivation ];
  };
}
