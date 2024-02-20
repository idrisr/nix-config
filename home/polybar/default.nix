{
  # theme https://github.com/adi1090x/polybar-themes#-polybar-5
  config = {
    services.polybar = {
      enable = true;
      config = ./config.ini;
      script = ''
        polybar top &
        polybar bottom &
      '';
    };
  };
}
