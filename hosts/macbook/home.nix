{ lib, inputs, ... }:
{
  disabledModules = [
    (inputs.home-config + "/modules/anki")
  ];

  home.stateVersion = lib.mkDefault "24.11";

  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = lib.mkForce false;

  programs.home-manager.enable = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
}
