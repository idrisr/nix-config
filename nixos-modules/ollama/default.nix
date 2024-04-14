{ lib, ... }: {
  config = {
    services.ollama = {
      listenAddress = "0.0.0.0:11111";
      enable = true;
      acceleration = "cuda";
    };
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
