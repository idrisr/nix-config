# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-rpi.nix
    <home-manager/nixos>
  ];

  config = {
    nix = {
      settings.trusted-users = [ "root" "hippoid" ];

      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };

    networking = {
      hostName = "rpi4";
      networkmanager.enable = true;
      firewall.allowedTCPPorts = [ 3000 ];
      firewall.allowedUDPPorts = [ 53 ];
    };

    security = {
      sudo.wheelNeedsPassword = false;
      rtkit.enable = true;
    };

    services = {
      tailscale = { enable = true; };
      openssh = {
        enable = true;
        passwordAuthentication = false;
        kbdInteractiveAuthentication = false;
      };
      adguardhome = {
        enable = true;
        openFirewall = true;
        settings.bind_port = 3000;
      };
    };

    # Configure keymap in X11
    console.useXkbConfig = true;

    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.utf8";
    services.printing.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    services.jack.alsa.enable = true;

    users.users.hippoid = {
      isNormalUser = true;
      description = "hippoid";
      extraGroups = [ "lpadmin" "networkmanager" "wheel" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqH1kHRyqND5ztdw+AwJpwL9a/ykIOkAVFqLQIyof2qDDdl7zgcKwnKmLi/vLn02xwdnt4JYXSCp0yvq3Qev5XmIyFsqneCqCTiN73XEI0OvwpIk2fl2LjoOg/Gg8zDC9bpn84Nr5+qSqLwFjk/+v99TNrEz1an/Z37/JDt786CssttXZ0PafPpyhZ8WTwPT1ORlMcBREauzXGWeetEKE04j/f2/xO8hqThe/aa8oW02+RjWpgD9VgG4MYg050A+0BwoVWpIjPf7IHGVCuY8js0CVvav1ERcb9wFCi1KGiEP2C0Vl/iki7iQU/lsPC8ZjmWcPZoRRgz+2neon4JDiGOS5eZAgzBCkNyJ4sMa8qSWN/cjQJn8oK+8sHclauX3oK0MT5byyWq/K1Q8wx5ItLQWoWr/O4xoMVN1gWdjCvc+9FaFjgtfxVsKIJBXUslOz1qq3oTWC0c03LUeHvd6VquXmVDUYsn8knGlkZNqeCpPNmw96v4VlT25Er9MsQ200= idris@bluebird"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBnLwTsGb2LKD+lGVjQfcjyuAvwZuNuHei1PqgkKVp25L+qjw2A408xRtUMW65OIPBcGVxZF4DAqU2LPjUp+E71xJFGOcxnpDh1YskMfas5dNyQ+jOIWntctPxrns9pxKZUNWBfGWqP73XSr0y8029Ct+Wc96r5NJu9cTtN0kI2L1hPI/t8ieb08AFvEdmcdqoGct5PgbWA+b+Z7LBiIQqY6s+BdXoqZYqktjQxdEaTD5eYj8Hi4W+AxOpm6S9fpclFULEKY01vnwK3CuGJH+Fv5evawzr2ppILUVxVPI7d53e0qewVwq2aKWynbKwuM3Dc9maVeNDfCtGt713P4+oILWLKdd5TkH2tKxNnD+/fFmMUUAn+YPcF7QnCfUhlBY6/pPcxUibIWkulKraazCljCXStIbqNq7t8ONKvtod4Zfc1+3W4usMbIiVF6Dm/+FkFpLhzVQZWtJLHbVxRsp3+M+Q+CklsMYrFoXlIFC5B51Uzpo/W4rncd9Nu6WXbwpFRpabbGENABFLkPa9bXacgvujirvW6BEOr1GpeWzTeB6OvXiHWOZ7JVEWn4ukcl5JoOmO0qifmuq65b85imI4L2PzjQdaduu87/ygz7R5Jr5y1JC+GWrv95NtDywxFzwCQWGN8NmK49pXtZ1HAcYFayIckBmwExF5gLGkoNIgfw== user@ipad"
      ];
    };

    environment = {
      systemPackages = let in with pkgs; [ home-manager vim sg3_utils ];

      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        PAGER = "";
      };
    };
    system.stateVersion = "22.05";
  };
}
