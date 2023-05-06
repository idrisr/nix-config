{ config, lib, pkgs, ... }:
with lib; {
  options = {
    machine = {
      enable = mkEnableOption "machine" { default = true; };

      host = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "machine host name";
      };

      virtualization = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "qemu/kvm setup";
      };

      graphical = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "whether to do all the graphical app stuff";
      };

      hardware = lib.mkOption {
        type = lib.types.path;
        description = "hardware specific import";
      };
    };
  };
}
