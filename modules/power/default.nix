{ lib, ... }:
{
  config = {
    services = {
      acpid = {
        enable = true;
        logEvents = true;
      };

      logind.settings.Login = {
        HandlePowerKey = lib.mkDefault "ignore";
        HandlePowerKeyLongPress = lib.mkDefault "ignore";
        HandleLidSwitch = lib.mkDefault "lock";
      };
    };
  };
}
