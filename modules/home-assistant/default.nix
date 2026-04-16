{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.home-assistant;
  haPythonPkgs = pkgs.home-assistant.python.pkgs;

  etekcityEsf551Ble = haPythonPkgs.buildPythonPackage rec {
    pname = "etekcity-esf551-ble";
    version = "0.4.1";
    pyproject = true;

    src = pkgs.fetchPypi {
      pname = "etekcity_esf551_ble";
      inherit version;
      hash = "sha256-1m92ZZ8uCt2RU5/YvxU37RIi5lH8Wk4QJwfO8hz1260=";
    };

    build-system = [ haPythonPkgs.hatchling ];

    dependencies = [
      haPythonPkgs.bleak
      haPythonPkgs."bleak-retry-connector"
    ];

    pythonImportsCheck = [ "etekcity_esf551_ble" ];
  };

  etekcityFitnessScaleBle = pkgs.buildHomeAssistantComponent rec {
    owner = "ronnnnnnnnnnnnn";
    domain = "etekcity_fitness_scale_ble";
    version = "0.4.2";

    src = pkgs.fetchFromGitHub {
      inherit owner;
      repo = domain;
      rev = "v${version}";
      hash = "sha256-7yVmZ9pu1Bbir/1z9bEPZBt47nyJs2oq3nau7U4ZuF4=";
    };

    dependencies = [ etekcityEsf551Ble ];
  };
in
{
  options = {
    home-assistant = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          enable home-assistant
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = false;
      extraComponents = [
        "bluetooth"
        "bluetooth_adapters"
        # Components required to complete the onboarding
        "esphome"
        "met"
        "radio_browser"
        "reolink"
        "tplink"
        "zha"
      ];
      customComponents = [ etekcityFitnessScaleBle ];
      config = {
        # Includes dependencies for a basic setup
        # https://www.home-assistant.io/integrations/default_config/
        default_config = { };
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [ "127.0.0.1" "::1" ];
        };
      };
    };
  };
}
