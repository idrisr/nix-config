{ pkgs, lib, ... }: {
  hardware.rtl-sdr.enable = true;
  users.users.hippoid.extraGroups = [ "plugdev" ];

  services.sdrplayApi.enable = true;

  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "sdrplay" ];
    overlays = [
      (_: prev: {
        soapysdr-with-plugins = prev.soapysdr.override {
          extraPackages = with prev; [ soapyrtlsdr ];
        };
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    rtl-sdr
    soapysdr-with-plugins
    soapyremote
  ];
}
