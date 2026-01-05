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
    ./immich
    ./kmonad
    ./locate
    ./opnsense-backup
    ./nh
    ./nvidia
    ./ollama
    ./passkey
    ./pinchflat
    ./printer/printer-client.nix
    ./reading
    ./rustdesk
    ./sdr
    ./superdrive.nix
    ./syncthing
    ./unifi
    ./virtualization
    ./vikunja

    inputs.disko.nixosModules.default
  ];
}
