{ config, lib, ... }:
with lib;
let cfg = config.ollama;
in {
  options = {
    ollama = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable ollama
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    nvidia-gpu.enable = true;
    services.ollama = {
      host = "0.0.0.0";
      port = 11111;
      enable = true;
      acceleration = "cuda";
    };
    # todo make port an option
    networking = { firewall = { allowedTCPPorts = [ 11111 ]; }; };

    nixpkgs = {
      config.allowUnfree = true;
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cudatoolkit-12.2.2"
          "cudaPackages.cudatoolkit"
        ];
    };
  };
}
