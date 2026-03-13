{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    my.base.enable = true;
    my."initrd-remote-unlock".enable = true;
    unifi.enable = true;
    networking.adblocker.enable = true;
    users.users.root = {
      hashedPassword = "$y$j9T$BowmS9BT0LZ5WNT1V4Day1$dae0REqJAJuNehr7b3Uj3Zy.dToJ30mwOqugbA39b02";
    };
    my.prometheus-server.enable = true;

    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "adguard.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
        "ai.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://192.168.8.231:13221";
            proxyWebsockets = true;
          };
        };
        "jellyfin.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://192.168.8.231:8096";
            proxyWebsockets = true;
          };
        };
        "immich.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://192.168.8.231:2283";
            proxyWebsockets = true;
          };
        };

        "grafana.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:3010";
            proxyWebsockets = true;
          };
        };

        "unifi.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "https://127.0.0.1:8443";
            proxyWebsockets = true;
          };
        };

        "prometheus.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090";
          };
        };

        "router.idrisraja.com" = {
          forceSSL = true;
          sslCertificate = "/etc/letsencrypt/live/idrisraja.com/fullchain.pem";
          sslCertificateKey = "/etc/letsencrypt/live/idrisraja.com/privkey.pem";
          locations."/" = {
            proxyPass = "http://192.168.8.1";
          };
        };
      };
    };


    boot = {
      kernelParams = [ "reboot=pci" ];
      initrd = {
        availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "igc" ];
        luks.devices."myvol" = {
          device = "/dev/disk/by-uuid/1004a810-9d15-4e13-b82e-e6cb48f4fd8b";
        };
      };

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/c21ec255-a3f9-4915-8492-7f7b1dc2876b";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/2010-27F2";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };
    };

    networking = {
      useDHCP = true;
      hostName = "godel";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
