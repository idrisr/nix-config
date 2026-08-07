{
  inputs,
  host,
  user,
  system,
}:
let
  mkDarwinConfiguration = host: inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit inputs host user;
    };
    modules = [
      (
        { pkgs, ... }:
        {
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          nixpkgs.hostPlatform = system;
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.home-config.overlays.default ];
          networking.hostName = host;
          system.primaryUser = user;
          system.keyboard = {
            enableKeyMapping = true;
            swapCapsLockAndEscape = true;
            swapLeftCtrlAndFn = true;
          };
          users.users.${user}.home = "/Users/${user}";
          security.sudo.extraConfig = ''
            ${user} ALL=(ALL) NOPASSWD: ALL
          '';

          environment.systemPackages = with pkgs; [
            git
            curl
            prometheus-node-exporter
          ];

          system.stateVersion = 4;
        }
      )
      ./hosts/macbook/default.nix

      inputs.home-manager.darwinModules.home-manager
      (
        { pkgs, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit pkgs;
            graphical = true;
          };
          home-manager.users.${user} = {
            imports = [
              (inputs."home-config" + "/home.nix")
              ./hosts/macbook/home.nix
            ];
          };
        }
      )
    ];
  };
in
{
  darwinConfigurations = {
    ${host} = mkDarwinConfiguration host;
    macbook = mkDarwinConfiguration "macbook";
  };
}
