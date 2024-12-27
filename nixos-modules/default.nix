{ inputs, ... }: {
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./base.nix
    ./borg/borg.nix
    ./desktop.nix
    ./docker
    ./fprintd
    ./home-assistant
    ../home-manager
    ./hoogle
    ./kmonad
    ./monitoring
    ./nh
    ./nixvim
    ./nvidia
    ./ollama
    ./printer/printer-client.nix
    ./reading
    ./sdr
    ./stylix
    ./superdrive.nix
    ./syncthing
    ./unifi

    inputs.nixvim.nixosModules.nixvim
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
}
