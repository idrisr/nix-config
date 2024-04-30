{ inputs, ... }: {
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./base.nix
    ./borg/borg.nix
    ./desktop.nix
    ./monitoring
    ./superdrive.nix
    ../home-manager
    ./nixvim
    ./reading
    ./nh
    ./docker
    ./nvidia
    ./sdr
    ./home-assistant
    ./ollama
    inputs.nixvim.nixosModules.nixvim
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
  ];
}
