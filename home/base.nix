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
          ];
          f = pkgs.lib.getName;
        in pkg: builtins.elem (f pkg) xs;
      };

      overlays = let
        h = x: ./overlays + "/${x}.nix";
        xs = map h [
          "awscost"
          "dimensions"
          "epubthumbnailer"
          "roamamer"
          "mdtopdf"
          "newcover"
          "transcribe"
        ];
      in map import xs;
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
