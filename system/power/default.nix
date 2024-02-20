{
  config = {
    services = {
      acpid = {
        enable = true;
        logEvents = true;
      };

      logind = {
        powerKey = "ignore";
        powerKeyLongPress = "ignore";
        lidSwitch = "lock";
      };
    };
  };
}
