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
    ./monitoring
    ./nh
    ./unifi
    ./nixvim
    ./nvidia
    ./ollama
    ./reading
    ./sdr
    ./superdrive.nix

    inputs.nixvim.nixosModules.nixvim
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
}
