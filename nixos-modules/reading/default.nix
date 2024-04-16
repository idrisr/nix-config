{ pkgs, lib, config, ... }:
let cfg = config.profile.rofi-book-search;
in {
  imports = [ ];
  options = {
    profile.rofi-book-search.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "rofi book launcher";
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        (callPackage ./desktop-item.nix { })
        (callPackage ./rofi-launcher.nix { })
      ];
    };
  };
}
