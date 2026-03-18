{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.ollama;
  ollama_port = 11111;
in
{
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
      enable = false;
      host = "0.0.0.0";
      port = 13221;
      openFirewall = true;
      environment = {
        WEBUI_AUTH = "False";
        OLLAMA_BASE_URL = "http://127.0.0.1:${builtins.toString ollama_port}";
      };
    };
    # need litellm
    services.ollama = {
      host = "0.0.0.0";
      port = 11111;
      enable = true;
      package = pkgs.ollama-cuda;
      openFirewall = true;
      loadModels = [ "deepseek-r1" ];
    };

    nixpkgs = {
      config.allowUnfree = true;
    };
  };
}
