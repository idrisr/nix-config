let base = [ ./configuration.nix ];
in {
  fft = {
    config = {
      machine = {
        host = "fft";
        virtualization = true;
        graphical = true;
      };
    };

    imports = [ ./hardware-surface.nix base ];
  };
}
