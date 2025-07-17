{ lib, host, ... }: {
  # things to redo
  # <shift>"=y, copy to system clipboard
  # <ctrl>bw tmux session switcher
  services.kmonad = {
    enable = true;

    keyboards."framework" = lib.mkIf (host == "framework") {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      defcfg = {
        fallthrough = true;
        enable = true;
        allowCommands = false;
      };
      config = builtins.readFile ./caps.kbd;
    };

keyboards."frameland" = lib.mkIf (host == "frameland") {
      device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      defcfg = {
        fallthrough = true;
        enable = true;
        allowCommands = false;
      };
      config = builtins.readFile ./caps.kbd;
    };

    keyboards."apple-numpad" = lib.mkIf (host == "fft") {
      device = "/dev/input/by-id/usb-Apple_Inc._Apple_Keyboard-event-kbd";
      defcfg = {
        fallthrough = true;
        enable = true;
        allowCommands = false;
      };
      config = builtins.readFile ./apple-numpad.kbd;
    };

    keyboards."surface" = lib.mkIf (host == "surface") {
      device = "/dev/input/by-path/platform-MSHW0343:00-event-kbd";
      defcfg = {
        fallthrough = true;
        enable = true;
        allowCommands = false;
      };
      config = builtins.readFile ./config.kbd;
    };
  };
}
