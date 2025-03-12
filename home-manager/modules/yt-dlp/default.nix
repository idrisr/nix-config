{
  config = {
    programs = {
      freetube.enable = true;
      yt-dlp = {
        enable = true;
        extraConfig = ''
          --paths=home:~/videos/
          --paths=temp:/tmp/
          --convert-subs srt
        '';

        # --output "%(playlist_index)02d - %(title)s.%(ext)s"
        settings = {
          write-auto-subs = true;
          embed-chapters = true;
          sub-langs = "en";
          downloader = "aria2c";
          downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
        };
      };
    };
  };
}
