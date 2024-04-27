{
  services.frigate = {
    enable = true;
    hostname = "fft";
    settings.cameras = { };
  };
  services.home-assistant = {
    config = { };
    enable = true;
  };
}
