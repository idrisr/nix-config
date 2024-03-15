{
  config = {
    services.slskd = {
      enable = false;
      nginx = { enable = false; };

      # openFirewall = false;
      # environmentFile = "/home/hippoid/soulseek";
      # settings = {
      # shares.directories = [ "/home/hippoid/music" ];
      # soulseek.username = "hippoid";
      # directories.downloads = "/home/hippoid/downloads/music";
      # };
    };
  };
}
