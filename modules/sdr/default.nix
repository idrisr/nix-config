{ config
, pkgs
, lib
, ...
}:
with lib; let
  cfg = config.sdr;
  mhz = x: x * 1000 * 1000;
in
{
  options = {
    sdr = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable software defined radio
        '';
      };

      enableSdrplay = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable SDRplay support and API service
        '';
      };

      remote = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            enable SoapyRemote server for network SDR access
          '';
        };

        openFirewall = mkOption {
          default = true;
          type = types.bool;
          description = lib.mdDoc ''
            open TCP 55132 for SoapyRemote
          '';
        };
      };

      web = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            enable OpenWebRX web UI for SDR listening
          '';
        };

        port = mkOption {
          default = 8073;
          type = types.port;
          description = lib.mdDoc ''
            TCP port for OpenWebRX
          '';
        };

        openFirewall = mkOption {
          default = true;
          type = types.bool;
          description = lib.mdDoc ''
            open OpenWebRX TCP port in the firewall
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.rtl-sdr.enable = true;
    users.users.hippoid.extraGroups = [ "plugdev" ];
    services.sdrplayApi.enable = cfg.enableSdrplay;

    nixpkgs = mkMerge [
      {
        overlays = [
          (_: prev: {
            soapysdr-with-plugins = prev.soapysdr.override {
              extraPackages =
                with prev;
                [ soapyrtlsdr soapyremote ]
                ++ lib.optionals cfg.enableSdrplay [ sdrplay ];
            };
          })
        ];
      }
      (mkIf cfg.enableSdrplay {
        config.allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [ "sdrplay" ];
      })
    ];

    environment.systemPackages = with pkgs; [
      rtl-sdr
      soapysdr-with-plugins
      soapyremote
    ];

    systemd.services.soapyremote = mkIf cfg.remote.enable {
      description = "SoapyRemote SDR server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = "hippoid";
        Group = "users";
        SupplementaryGroups = [ "plugdev" ];
        Environment = [
          "SOAPY_SDR_PLUGIN_PATH=${concatStringsSep ":" ([
            "${pkgs.soapyrtlsdr}/lib/SoapySDR/modules0.8-3"
            "${pkgs.soapyremote}/lib/SoapySDR/modules0.8-3"
          ] ++ lib.optionals cfg.enableSdrplay [
            "${pkgs.sdrplay}/lib/SoapySDR/modules0.8-3"
          ])}"
        ];
        ExecStart = "${pkgs.soapyremote}/bin/SoapySDRServer --bind";
        Restart = "on-failure";
        RestartSec = "2s";
      };
    };

    services.openwebrx.enable = cfg.web.enable;
    environment.etc."openwebrx/openwebrx.conf" = mkIf cfg.web.enable {
      text = ''
        [web]
        port = ${toString cfg.web.port}
      '';
    };
    environment.etc."openwebrx/settings.bootstrap.json" =
      mkIf cfg.web.enable {
        text = builtins.toJSON {
          sdrs = {
            rtlsdr = {
              name = "RTL-SDR USB Stick";
              type = "rtl_sdr";

              profiles = {
                am_broadcast = {
                  name = "AM Broadcast";
                  center_freq = 1200000;
                  samp_rate = 2048000;
                  start_freq = 720000;
                  start_mod = "am";
                  rf_gain = 20;
                  direct_sampling = 2;
                };
                ord_tower = {
                  name = "ORD Tower AM 133.625";
                  samp_rate = 1024000;
                  start_freq = mhz 133.625;
                  center_freq = mhz 133.625;
                  start_mod = "am";
                  rf_gain = 37;
                  direct_sampling = 0;
                };
                ord_approach =
                  {
                    name = "ORD Approach AM 120.750";
                    samp_rate = 1024000;
                    start_freq = mhz 120.75;
                    center_freq = mhz 120.75;
                    start_mod = "am";
                    rf_gain = 37;
                    direct_sampling = 0;
                  };

                fm_broadcast =
                  let freq = mhz 93.1;
                  in {
                    name = "xrt";
                    center_freq = freq;
                    samp_rate = 2400000;
                    start_freq = freq;
                    start_mod = "wfm";
                    rf_gain = 20;
                    direct_sampling = 0;
                  };

                npr_broadcast =
                  let freq = mhz 91.5;
                  in {
                    name = "npr";
                    center_freq = freq;
                    samp_rate = 2400000;
                    start_freq = freq;
                    start_mod = "wfm";
                    rf_gain = 20;
                    direct_sampling = 0;
                  };

                noaa_broadcast =
                  let freq = mhz 162.55; in
                  {
                    name = "noaa";
                    center_freq = freq;
                    samp_rate = 2400000;
                    start_freq = freq;
                    start_mod = "wfm";
                    rf_gain = 20;
                    direct_sampling = 0;
                  };

                adsb =
                  let freq = mhz 1090; in
                  {
                    name = "ADS-B 1090";
                    center_freq = freq;
                    samp_rate = 2400000;
                    start_freq = freq;
                    start_mod = "nfm";
                    rf_gain = 37;
                    direct_sampling = 0;
                  };
              };
            };
          };
        };
      };

    systemd.services.openwebrx = mkIf cfg.web.enable {
      preStart = ''
                set -eu

                if [ ! -f /var/lib/openwebrx/settings.json ]; then
                  cp /etc/openwebrx/settings.bootstrap.json /var/lib/openwebrx/settings.json
                  chmod 0600 /var/lib/openwebrx/settings.json
                else
                  ${pkgs.python3Minimal}/bin/python3 - <<'PY'
        import json

        settings_path = "/var/lib/openwebrx/settings.json"
        bootstrap_path = "/etc/openwebrx/settings.bootstrap.json"

        with open(bootstrap_path, "r", encoding="utf-8") as f:
            bootstrap = json.load(f)

        with open(settings_path, "r", encoding="utf-8") as f:
            settings = json.load(f)

        changed = False

        bootstrap_rtl = bootstrap.get("sdrs", {}).get("rtlsdr", {})
        settings_sdrs = settings.setdefault("sdrs", {})

        if "rtlsdr" not in settings_sdrs:
            settings_sdrs["rtlsdr"] = bootstrap_rtl
            changed = True

        settings_rtl = settings_sdrs.setdefault("rtlsdr", {})
        bootstrap_profiles = bootstrap_rtl.get("profiles", {})
        settings_profiles = settings_rtl.setdefault("profiles", {})

        for profile_name, profile in bootstrap_profiles.items():
            if profile_name not in settings_profiles:
                settings_profiles[profile_name] = profile
                changed = True
                continue

            current_profile = settings_profiles.get(profile_name)
            if not isinstance(current_profile, dict):
                settings_profiles[profile_name] = profile
                changed = True
                continue

            for key, value in profile.items():
                if current_profile.get(key) != value:
                    current_profile[key] = value
                    changed = True

        if changed:
            with open(settings_path, "w", encoding="utf-8") as f:
                json.dump(settings, f, indent=2)
                f.write("\n")
        PY
                fi
      '';
      serviceConfig = {
        DynamicUser = mkForce false;
        User = "hippoid";
        Group = "users";
        SupplementaryGroups = [ "plugdev" ];
      };
    };

    networking.firewall.allowedTCPPorts =
      optionals (cfg.remote.enable && cfg.remote.openFirewall) [ 55132 ]
      ++ optionals (cfg.web.enable && cfg.web.openFirewall) [ cfg.web.port ];
  };
}
