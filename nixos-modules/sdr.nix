{ pkgs, lib, ... }: {
  hardware.rtl-sdr.enable = true;
  users.users.hippoid.extraGroups = [ "plugdev" ];

  services.sdrplayApi.enable = true;

  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "sdrplay" ];
    overlays = [
      (self: super: {
        soapysdr-with-plugins = super.soapysdr.override {
          extraPackages = with super; [ soapyrtlsdr ];
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
