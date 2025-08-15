{ modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  boot.kernelParams = [ "console=ttyS0,115200" "console=tty1" "video=HDMI-A-1:1024x600@60" ];
  networking = {
    useDHCP = true;
    firewall.allowedTCPPorts = [ 22 ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.root.openssh.authorizedKeys.keys =
    [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsnWJFXUmPQeaDEAmN7Dwyulu2WAiNTd1FesWJFfyi/ hippoid@framework"
    ];

  system.stateVersion = "25.05";
}
