{ config, lib, ... }:
with lib;
let
  cfg = config.ollama;
  ollama_port = 11111;
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
    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 13221;
      openFirewall = true;
      environment = {
        WEBUI_AUTH = "False";
        OLLAMA_BASE_URL = "http://127.0.0.1:${builtins.toString ollama_port}";
      };

    };
    services.ollama = {
      host = "0.0.0.0";
      port = 11111;
      enable = true;
      acceleration = "cuda";
      openFirewall = true;
    };

    nixpkgs = {
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "cudatoolkit-12.2.2"
          "cudaPackages.cudatoolkit"
        ];
      config.allowUnfree = true;
    };
  };
}
