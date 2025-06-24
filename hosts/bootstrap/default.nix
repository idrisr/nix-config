{ modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  boot.kernelParams = [ "console=ttyS0,115200" ];
  networking = {
    useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.root.openssh.authorizedKeys.keyFiles =
    [ ../../nixos-modules/public-keys/id_ed25519-framework.pub ];

  system.stateVersion = "24.11";
}
