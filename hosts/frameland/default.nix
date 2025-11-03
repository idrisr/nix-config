{ pkgs, ... }:

{
  imports = [ ../framework/hardware-framework.nix ];
  config = {
    my.base.enable = true;
    my.opnsenseBackup.enable = true;
    my.pinchflat.enable = true;
    my.vikunja.enable = true;
    my.printer.enable = true;
    borg-backup-client.enable = true;

    services.blueman.enable = true; # optional GUI
    hardware.bluetooth.enable = true;

    fonts.packages = with pkgs; [
      eb-garamond
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;

        configPackages = [
          # (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
          # monitor.bluez.properties = {
          # bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
          # bluez5.codecs = [ sbc sbc_xq aac ]
          # bluez5.enable-sbc-xq = true
          # bluez5.hfphsp-backend = "native"
          # }
          # '')
          # (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/20-stuff.conf" ''
          # wireplumber.components = [
          # {
          # name = libwireplumber-module-dbus-connection,
          # type = module
          # provides = support.dbus
          # }
          # {
          # name = libwireplumber-module-reserve-device,
          # type = module
          # provides = support.reserve-device
          # requires = [ support.dbus ]
          # }
          # {
          # name = monitors/alsa.lua,
          # type = script/lua
          # provides = monitor.alsa
          # wants = [ support.reserve-device ]
          # }
          # ]

          # wireplumber.profiles = {
          # main = {
          # monitor.alsa = required
          # }
          # }
          # '')
        ];
      };
    };

    services.upower.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.kdePackages.xdg-desktop-portal-kde
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.firewall.enable = false;

    programs.noisetorch.enable = true;

    users = {
      groups.hippoid = { };
      users.hippoid = {
        isNormalUser = true;
        group = "hippoid";
        extraGroups = [ "wheel" ];
      };
    };

    security.sudo.wheelNeedsPassword = false;
    environment.systemPackages = with pkgs; [ vifm vim git curl ];

    services = {
      openssh.enable = true;
    };
  };
}
