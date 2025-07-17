{ pkgs, config, lib, ... }:
with lib;
let cfg = config.passkey;
in {
  options = {
    passkey = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable yubikey
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.pcscd.enable = true;
    environment.systemPackages = with pkgs; [
      age-plugin-yubikey
      pcsclite
      yubico-piv-tool
      yubikey-manager
      yubikey-personalization
      yubioath-flutter
    ];
  };
}
