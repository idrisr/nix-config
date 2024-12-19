let
  mkFolderShare = name: {
    path = "/home/hippoid/${name}";
    devices = [ "surface" "framework" ];
    vesioning = {
      type = "staggered";
      params = {
        cleanInterval = "3600";
        maxAge = "15768000";
      };
    };
  };

in {
  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      user = "hippoid";
      group = "users";
      guiAddress = "localhost:8384";

      configDir = "/home/hippoid/.config/syncthing";
      settings = {
        options.urAccepted = -1;
        options.relaysEnabled = false;
        devices = {
          surface.id =
            "5BM7GQY-F3QYSDR-UEW2GMA-IICKXDD-NFH5BEE-TSU4TIN-BSBGSPQ-JEPLSAJ";
          framework.id =
            "PNAM4JI-5E5CRM6-YVD6CT4-Z6D7XQD-JARNY3R-FLGG2YY-62IHSVV-ARVFGAY";
        };

        folders = {
          "fun" = mkFolderShare "fun";
          "books" = mkFolderShare "books";
          "downloads" = mkFolderShare "downloads";
          "videos" = mkFolderShare "videos";
          "documents" = mkFolderShare "documents";
          "roam-export" = mkFolderShare "roam-export";
          "screenshots" = mkFolderShare "screenshots";
        };
      };
    };
  };
}
