{ inputs, ... }: {
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./audiobookshelf
    ./base.nix
    ./borg/borg.nix
    ./borg/borgrepo.nix
    ./desktop.nix
    ./docker
    ./fprintd
    ./frigate
    ./home-assistant
    ../home-manager
    ./hoogle
    ./immich
    ./kmonad
    ./locate
    ./monitoring
    ./nh
    ./nvidia
    ./ollama
    ./passkey
    ./printer/printer-client.nix
    ./reading
    ./rustdesk
    ./sdr
    ./stylix
    ./superdrive.nix
    ./syncthing
    ./unifi
    ./virtualization

    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    { home-manager.sharedModules = [ inputs.nixcord.homeModules.nixcord ]; }
  ];
}
