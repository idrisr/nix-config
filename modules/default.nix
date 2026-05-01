{ inputs, ... }:
{
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./anki
    ./audiobookshelf
    ./base.nix
    ./borg/borg.nix
    ./borg/borgrepo.nix
    ./desktop.nix
    ./docker
    ./droidcam
    ./esphome
    ./fprintd
    ./frigate
    ./home-assistant
    ./hyprland-support.nix
    ./hoogle
    ./jellyfin.nix
    ./immich
    ./initrd-remote-unlock.nix
    ./kavita
    ./kmonad
    ./local-host-overrides.nix
    ./locate
    ./mediamtx-webcam
    ./music-assistant.nix
    ./navidrome.nix
    ./opnsense-backup
    ./nh
    ./nvidia
    ./ollama
    ./opencode
    ./passkey
    ./pinchflat
    ./pipewire
    ./printer/printer-client.nix
    ./reading
    ./redmine.nix
    ./rustdesk
    ./tailscale/client.nix
    ./tailscale/server.nix
    ./sdr
    ./slskd.nix
    ./superdrive.nix
    ./syncthing
    ./unifi
    ./virtualization
    ./vikunja
    ./wifi-iperf-monitor

    inputs.disko.nixosModules.default
  ];
}
