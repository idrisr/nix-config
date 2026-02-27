{ inputs, ... }: {
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
    ./fprintd
    ./frigate
    ./home-assistant
    ./hyprland-support.nix
    ./hoogle
    ./jellyfin.nix
    ./light
    ./immich
    ./kmonad
    ./locate
    ./opnsense-backup
    ./nh
    ./nvidia
    ./ollama
    ./opencode
    ./passkey
    ./pinchflat
    ./pipewire
    ./printer/printer-client.nix
    ./reverse-proxy.nix
    ./reading
    ./redmine.nix
    ./rustdesk
    ./tailscale/client.nix
    ./tailscale/server.nix
    ./sdr
    ./superdrive.nix
    ./syncthing
    ./unifi
    ./virtualization
    ./vikunja

    inputs.disko.nixosModules.default
  ];
}
