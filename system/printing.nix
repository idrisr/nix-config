{ config, pkgs, lib, ... }: {
  config = {
    services = {
      printing = {
        drivers = [ pkgs.brlaser ];
        enable = true;
      };
    };
    users.users.hippoid = { extraGroups = [ "lp" ]; };
  };
}
