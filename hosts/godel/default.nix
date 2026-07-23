{
  config,
  lib,
  modulesPath,
  pkgs,
  inputs,
  ...
}:
let
  acmeHost = "idrisraja.com";
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    my.base.enable = true;
    my.mediamtxWebcam.enable = true;
    my.mediamtxWebcam.videoDevice = "/dev/video1";
    my.mealie.enable = true;
    my.music-assistant.enable = true;
    services.music-assistant.providers = [
      "opensubsonic"
      "dlna"
      "airplay"
      "sendspin"
    ];
    my.navidrome.enable = true;
    my.audiobookshelf.enable = true;
    my.slskd.enable = true;
    my.paperless.enable = true;
    home-assistant.enable = true;

    my."initrd-remote-unlock".enable = true;
    my.servernode.enable = false;
    unifi.enable = true;
    networking.adblocker.enable = true;
    users.users.root = {
      hashedPassword = "$y$j9T$BowmS9BT0LZ5WNT1V4Day1$dae0REqJAJuNehr7b3Uj3Zy.dToJ30mwOqugbA39b02";
    };
    users.groups.hippoid = { };
    users.users.hippoid.extraGroups = [ "hippoid" ];
    my.prometheus-server.enable = true;
    my.hdhomerun-monitor = {
      enable = true;
      deviceIp = "192.168.8.103";
    };
    services.iperf3 = {
      enable = true;
      openFirewall = true;
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        graphical = false;
        pkgs = pkgs;
      };
      users.hippoid = import (inputs."home-config" + "/home.nix");
    };

    services.zfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
      5004
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "idris.raja@gmail.com";
      certs.${acmeHost} = {
        dnsProvider = "namecheap";
        environmentFile = "/var/lib/acme/namecheap.env";
        group = "nginx";
        reloadServices = [ "nginx.service" ];
        extraDomainNames = [ "*.idrisraja.com" ];
      };
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      streamConfig = ''
        server {
          listen 5004;
          proxy_pass 192.168.8.103:5004;
        }
      '';
      virtualHosts = {
        "adguard.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
          };
        };
        "ai.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:13221";
            proxyWebsockets = true;
          };
        };
        "airplane.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231/tar1090/";
            proxyWebsockets = true;
          };
        };
        "sdr.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:8073";
            proxyWebsockets = true;
          };
        };
        "jellyfin.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:8096";
            proxyWebsockets = true;
          };
        };
        "immich.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:2283";
            proxyWebsockets = true;
          };
        };

        "grafana.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:3010";
            proxyWebsockets = true;
          };
        };

        "kismet.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:2501";
            proxyWebsockets = true;
          };
        };

        "unifi.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "https://127.0.0.1:8443";
            proxyWebsockets = true;
          };
        };

        "prometheus.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9090";
          };
        };

        "mealie.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:9000";
          };
        };

        "navidrome.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:4533";
            proxyWebsockets = true;
          };
        };

        "musicassistant.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8095";
            proxyWebsockets = true;
          };
        };

        "slskd.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:5030";
          };
        };

        "audiobookshelf.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
            proxyWebsockets = true;
          };
        };

        "frigate.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:80";
            proxyWebsockets = true;
          };
        };

        "homeassistant.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://127.0.0.1:8123";
            proxyWebsockets = true;
          };
        };

        "esphome.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."/" = {
            proxyPass = "http://192.168.8.231:6052";
            proxyWebsockets = true;
          };
        };

        "tv.idrisraja.com" = {
          forceSSL = true;
          useACMEHost = acmeHost;
          locations."= /" = {
            proxyPass = "http://192.168.8.103:80";
          };
          locations."/live/" = {
            extraConfig = ''
              rewrite ^/live/(.+)$ /auto/v$1 break;
              proxy_pass http://192.168.8.103:5004;
            '';
          };
          locations."/" = {
            proxyPass = "http://192.168.8.103:80";
          };
        };

      };
    };

    boot = {
      supportedFilesystems = [ "zfs" ];
      kernelParams = [ "reboot=pci" ];
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
          "igc"
        ];
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
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    networking = {
      useDHCP = true;
      hostName = "godel";
      hostId = "2af3cd91";
    };

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
