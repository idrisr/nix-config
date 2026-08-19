{ inputs, ... }:
let
  nixpkgsConfig =
    { lib, ... }:
    {
      nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
        overlays = [ inputs."home-config".overlays.default ];
        config.allowUnfree = true;
        config.packageOverrides = pkgs: {
          pythonPackagesExtensions = pkgs.pythonPackagesExtensions ++ [
            (python-final: python-prev: {
              ai-edge-litert = python-prev.ai-edge-litert.overrideAttrs (old: {
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libopenvino.so.2620"
                  "libopenvino_tensorflow_lite_frontend.so.2620"
                ];
              });
            })
          ];
        };
      };
    };
in
{
  flake.modules.nixos.all = {
    imports = [
      nixpkgsConfig
      inputs.home-manager.nixosModules.home-manager
      inputs.disko.nixosModules.default
      ../../modules/ad-blocker.nix
      ../../modules/adsb
      ../../modules/anki
      ../../modules/audiobookshelf
      ../../modules/avahi.nix
      ../../modules/base.nix
      ../../modules/borg/borg.nix
      ../../modules/borg/borgrepo.nix
      ../../modules/desktop.nix
      ../../modules/docker
      ../../modules/droidcam
      ../../modules/esphome
      ../../modules/fprintd
      ../../modules/frigate
      ../../modules/hdhomerun-monitor
      ../../modules/home-assistant
      ../../modules/hoogle
      ../../modules/hyprland-support.nix
      ../../modules/immich
      ../../modules/initrd-remote-unlock.nix
      ../../modules/jellyfin.nix
      ../../modules/kavita
      ../../modules/kismet
      ../../modules/kmonad
      ../../modules/local-host-overrides.nix
      ../../modules/platform-io
      ../../modules/locate
      ../../modules/mediamtx-webcam
      ../../modules/mealie
      ../../modules/mitmproxy
      ../../modules/music-assistant.nix
      ../../modules/navidrome.nix
      ../../modules/nh
      ../../modules/nfs-client.nix
      ../../modules/nix-index
      ../../modules/nvidia
      ../../modules/ollama
      ../../modules/opnsense-backup
      ../../modules/passkey
      ../../modules/paperless.nix
      ../../modules/pinchflat
      ../../modules/pipewire
      ../../modules/podgrab
      ../../modules/power
      ../../modules/printer/printer-client.nix
      ../../modules/printer/printing.nix
      ../../modules/prometheus-exporter
      ../../modules/prometheus-server
      ../../modules/reading
      ../../modules/redmine.nix
      ../../modules/rustdesk
      ../../modules/sdr
      ../../modules/slskd.nix
      ../../modules/superdrive.nix
      ../../modules/syncthing
      ../../modules/tailscale
      ../../modules/tailscale/client.nix
      ../../modules/tailscale/server.nix
      ../../modules/trackpad.nix
      ../../modules/unifi
      ../../modules/vikunja
      ../../modules/virtualization
      ../../modules/wifi-bssid-monitor
      ../../modules/wifi-iperf-monitor
    ];
  };
}
