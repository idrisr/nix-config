{ config, lib, pkgs, ... }: {

  imports = import ./imports.nix;

  options = {
    theme = {
      enable = lib.mkEnableOption "theme";
      color = lib.mkOption {
        type = lib.types.str;
        default = "dark";
      };
    };
  };

  config = {
    nixpkgs = {
      config = {
        allowUnfreePredicate = let
          xs = [
            "discord"
            "lastpass-cli"
            "steam-original"
            "steam-run"
            "gitkraken"
            "code"
            "vscode"
            "broadcom-sta"
          ];
          f = pkgs.lib.getName;
        in pkg: builtins.elem (f pkg) xs;
      };

      overlays = let xs = [ ./overlays/zettel-plugin.nix ]; in map import xs;
    };

    home = {
      username = "hippoid";
      homeDirectory = "/home/hippoid";
      stateVersion = "22.05";
      packages = import ./packages.nix pkgs;
    };

    # Let Home Manager install and manage itself.
    programs = { home-manager.enable = true; };
  };
}
