{ pkgs, ... }: {
  config = {
    services.picom = {
      enable = true;
      package = pkgs.picom;
    };
  };
}
