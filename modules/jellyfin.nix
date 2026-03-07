{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.jellyfin;
in {
  options = {
    my.jellyfin = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable jellyfin
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
    users.users.jellyfin = {
      description = "jellyfin";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [(builtins.readFile ./public-keys/jellyfin_ed25519.pub)];
    };
  };
}
