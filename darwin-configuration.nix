{ inputs, host, user, system }:
{
  darwinConfigurations.${host} = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs host user;
    };
    modules = [
      ({ pkgs, ... }: {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.hostPlatform = system;
        networking.hostName = host;
        users.users.${user}.home = "/Users/${user}";

        environment.systemPackages = with pkgs; [
          git
          curl
          prometheus-node-exporter
        ];

        system.stateVersion = 4;
      })
      ./hosts/macbook/default.nix

      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ./hosts/macbook/home.nix;
      }
    ];
  };
}
