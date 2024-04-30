{ config, lib, ... }:
with lib;
let cfg = config.home-assistant;
in {
  options = {
    home-assistant = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable home-assistant
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      extraComponents = [
        # Components required to complete the onboarding
        "esphome"
        "met"
        "radio_browser"
        "reolink"
      ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
      };
    };
  };
}
