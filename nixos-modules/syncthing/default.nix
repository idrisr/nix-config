{
  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      user = "hippoid";
      group = "users";
      guiAddress = "0.0.0.0:8384";

      settings.options.urAccepted = -1;
      settings.options.relaysEnabled = false;

      configDir = "/home/hippoid/.config/syncthing";
      devices = {
        surface.id =
          "5BM7GQY-F3QYSDR-UEW2GMA-IICKXDD-NFH5BEE-TSU4TIN-BSBGSPQ-JEPLSAJ";
        framework.id =
          "PNAM4JI-5E5CRM6-YVD6CT4-Z6D7XQD-JARNY3R-FLGG2YY-62IHSVV-ARVFGAY";
      };

      folders = {
        "syncme" = {
          path = "/home/hippoid/roam-export";
          devices = [ "surface" "framework" ];
          vesioning = {
            type = "staggered";
            params = {
              cleanInterval = "3600";
              maxAge = "15768000";
            };
          };
        };
      };
    };
  };
}
