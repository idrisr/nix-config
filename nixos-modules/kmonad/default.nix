{
  services.kmonad = {
    enable = true;
    keyboards."framework" = {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      defcfg = {
        fallthrough = true;
        enable = true;
        allowCommands = true;
      };
      config = builtins.readFile ./config.kbd;
    };
  };
}
