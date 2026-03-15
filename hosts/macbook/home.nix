{ pkgs, lib, inputs, ... }:
{
  disabledModules = [
    (inputs.home-config + "/modules/nixvim/config")
    (inputs.home-config + "/modules/opencode")
  ];

  home.stateVersion = lib.mkDefault "24.11";

  home.packages = [
    pkgs.mysides
  ];

  home.activation.finderHomeShortcut = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.mysides}/bin/mysides remove Home >/dev/null 2>&1 || true
    ${pkgs.mysides}/bin/mysides add Home "file:///Users/$USER"
  '';

  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = lib.mkForce false;

  programs.home-manager.enable = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
}
