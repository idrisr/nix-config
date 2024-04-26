{ ... }: {
  programs.kitty = {
    enable = true;
    font = {
      size = 9;
      name = "JetBrainsMono Nerd Font";
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };
}
