{ config, lib, pkgs, ... }:
let
  cfg = config.my."initrd-remote-unlock";
  # systemd-tty-ask-password-agent --watch
  # systemctl start initrd-switch-root.target
in
{
  options.my."initrd-remote-unlock" = {
    enable = lib.mkEnableOption "initrd SSH remote LUKS unlock";

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        (builtins.readFile ./public-keys/id_ed25519-framework.pub)
      ];
      description = "Authorized SSH public keys for initrd unlock access.";
    };

    hostKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      description = "Host keys used by initrd SSH server.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "rd.luks.options=tries=0,timeout=0"
      "rd.systemd.device-timeout=0"
    ];

    boot.initrd = {
      network = {
        enable = true;
        flushBeforeStage2 = true;
        ssh = {
          enable = true;
          authorizedKeys = cfg.authorizedKeys;
          hostKeys = cfg.hostKeys;
        };
        postCommands = "";
      };

      systemd = {
        enable = true;
        extraBin = {
          systemd-tty-ask-password-agent = "${pkgs.systemd}/bin/systemd-tty-ask-password-agent";
          ip = "${pkgs.iproute2}/bin/ip";
        };

        services."unlock-agent" = {
          wantedBy = [ "initrd.target" ];
          serviceConfig = {
            StandardOutput = "journal";
            ExecStart = "${pkgs.systemd}/bin/systemd-tty-ask-password-agent --watch";
            StandardError = "journal";
          };
        };
      };
    };
  };
}
