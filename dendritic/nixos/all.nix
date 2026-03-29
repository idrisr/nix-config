{ inputs, ... }:
let
  nixpkgsConfig = { lib, ... }: {
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
      overlays = [ inputs."home-config".overlays.default ];
      config.allowUnfree = true;
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
      ../../modules/anki
      ../../modules/audiobookshelf
      ../../modules/avahi.nix
      ../../modules/base.nix
      ../../modules/borg/borg.nix
      ../../modules/borg/borgrepo.nix
      ../../modules/desktop.nix
      ../../modules/docker
      ../../modules/droidcam
      ../../modules/fprintd
      ../../modules/frigate
      ../../modules/home-assistant
      ../../modules/hoogle
      ../../modules/hyprland-support.nix
      ../../modules/immich
      ../../modules/initrd-remote-unlock.nix
      ../../modules/jellyfin.nix
      ../../modules/kmonad
      ../../modules/locate
      ../../modules/mealie
      ../../modules/mitmproxy
      ../../modules/navidrome.nix
      ../../modules/nh
      ../../modules/nix-index
      ../../modules/nvidia
      ../../modules/ollama
      ../../modules/opnsense-backup
      ../../modules/passkey
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
      ../../modules/superdrive.nix
      ../../modules/syncthing
      ../../modules/tailscale
      ../../modules/tailscale/client.nix
      ../../modules/tailscale/server.nix
      ../../modules/unifi
      ../../modules/vikunja
      ../../modules/virtualization
    ];
  };
}
