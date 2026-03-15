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
        nixpkgs.config.allowUnfree = true;
        networking.hostName = host;
        system.primaryUser = user;
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
      ({ pkgs, ... }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inputs = inputs // {
            "idris-pkgs" = inputs.home-config;
          };
          inherit pkgs;
          graphical = true;
        };
        home-manager.users.${user} = {
          imports = [
            (inputs."home-config" + "/home.nix")
            ./hosts/macbook/home.nix
          ];
        };
      })
    ];
  };
}
