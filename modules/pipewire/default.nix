{ config, lib, ... }:
with lib;
let cfg = config.my.pipewire;
in {
  options = {
    my.pipewire = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable PipeWire and WirePlumber
        '';
      };
      airpods = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            pin AirPods to headset profile for microphone
          '';
        };
        deviceName = mkOption {
          default = "bluez_card.58_0A_D4_EB_A7_4B";
          type = types.str;
          description = lib.mdDoc ''
            BlueZ card name for the AirPods device
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      jack.enable = true;

      wireplumber = {
        enable = true;
        extraConfig = lib.optionalAttrs cfg.airpods.enable {
          "40-wireplumber-settings.conf" = {
            "wireplumber.settings" = {
              "bluetooth.autoswitch-to-headset-profile" = false;
              "device.restore-profile" = false;
            };
          };

          "50-bluetooth.conf" = {
            "monitor.bluez.properties" = {
              "bluez5.auto-switch-profile" = false;
            };
          };

          "51-airpods-headset.conf" = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  { "device.name" = cfg.airpods.deviceName; }
                ];
                actions = {
                  update-props = {
                    "bluez5.auto-switch-profile" = false;
                    "bluez5.profile" = "headset-head-unit";
                    "bluez5.roles" = [ "hsp_hs" "hfp_hf" ];
                    "device.profile" = "headset-head-unit";
                  };
                };
              }
            ];
          };
        };

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
  };
}
