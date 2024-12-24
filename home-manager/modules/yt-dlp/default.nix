{
  config = {
    programs = {
      freetube.enable = true;
      yt-dlp = {
        enable = true;
        extraConfig = ''
          --paths=home:~/videos/
          --paths=temp:/tmp/
        '';

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
