let
  wanMAC = "00:e0:67:30:ae:a6";
  lanMAC = "00:e0:67:30:ae:a7";
in {
  imports = [ ./disko.nix ];

  boot = {
    kernelParams = [ "console=ttyS0,115200" ];

    loader.grub = {
      enable = true;
      device = "nodev";
      extraConfig = ''
        serial --unit=0 --speed=115200
        terminal_input serial
        terminal_output serial
      '';
    };
  };

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.wan.useDHCP = true;
    hostName = "router";

    interfaces.lan.ipv4.addresses = [{
      address = "192.168.1.1";
      prefixLength = 24;
    }];

    nat = {
      enable = true;
      externalInterface = "wan";
      internalInterfaces = [ "lan" ];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = { interfaces = [ "lan" ]; };
      subnet4 = [{
        subnet = "192.168.1.0/24";
        pools = [{ pool = "192.168.1.100 - 192.168.1.200"; }];
        reservations = [{
          hw-address = "aa:bb:cc:dd:ee:ff";
          ip-address = "192.168.1.10";
        }];
        option-data = [{
          name = "routers";
          data = "192.168.1.1";
        }];
      }];
    };
  };

  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keyFiles =
    [ ../../nixos-modules/public-keys/id_ed25519-framework.pub ];

  system.stateVersion = "24.05";

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${wanMAC}", NAME="wan"
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${lanMAC}", NAME="lan"
  '';
}
