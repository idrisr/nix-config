{
  config = {
    services.prometheus.exporters = {
      systemd.enable = true;

      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "logind"
          "systemd"
        ];
        disabledCollectors = [ "textfile" ];
        openFirewall = true;
      };
    };
  };
}
