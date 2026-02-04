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
    ./printer/printer-client.nix
    ./reading
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
