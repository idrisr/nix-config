knotools:
let
  ol = (with knotools.overlays; [
    awscost
    booknote
    dimensions
    epubthumb
    mdtopdf
    newcover
    pdftc
    roamamer
    seder
    transcribe
  ]);
in { config, lib, pkgs, ... }: {

  imports = import ./imports.nix;

  config = {
    nixpkgs = {
      config = {
        permittedInsecurePackages = [ "adobe-reader-9.5.5" ];
        allowUnfreePredicate = let
          xs = [
            "adobe-reader"
            "broadcom-sta"
            "code"
            "discord"
            "gitkraken"
            "lastpass-cli"
            "vscode"
          ];
          f = pkgs.lib.getName;
        in pkg: builtins.elem (f pkg) xs;
      };

      overlays = (let xs = [ ./overlays/zettel-plugin.nix ]; in map import xs)
        ++ ol;
    };

    home = {
      username = "hippoid";
      homeDirectory = "/home/hippoid";
      stateVersion = "22.05";
      packages = (import ./packages.nix pkgs);
    };

    # Let Home Manager install and manage itself.
    programs = { home-manager.enable = true; };
  };
}
