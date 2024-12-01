{ inputs, ... }: {
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./base.nix
    ./borg/borg.nix
    ./desktop.nix
    ./docker
    ./home-assistant
    ../home-manager
    ./hoogle
    ./monitoring
    ./nh
    ./nixvim
    ./nvidia
    ./ollama
    ./printer/printer-client.nix
    ./reading
    ./sdr
    ./superdrive.nix
    ./unifi

    inputs.nixvim.nixosModules.nixvim
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
}
