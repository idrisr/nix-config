let imports = [ ./base.nix ];
in {
  dark = {
    inherit imports;
    config = {
      theme = {
        enable = true;
        color = "dark";
      };
    };
  };

  light = {
    inherit imports;
    config = {
      theme = {
        enable = true;
        color = "light";
      };
    };
  };
}
