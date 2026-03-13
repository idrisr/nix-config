{
  config = {
    services.prometheus.exporters = {
      systemd.enable = true;
      tailscale.enable = false;

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
