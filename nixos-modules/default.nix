{ inputs, ... }: {
  config = { };
  options = { };
  imports = [
    ./ad-blocker.nix
    ./audiobookshelf
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
    ./virtualization

    inputs.nixvim.nixosModules.nixvim
    inputs.disko.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.sharedModules =
        [ inputs.nixcord.homeManagerModules.nixcord ];
    }
  ];
}
