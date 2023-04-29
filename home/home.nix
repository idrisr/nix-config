{
  dark = {
    imports = [ ./base.nix ];
    config = {
      theme = {
        enable = true;
        color = "dark";
      };
    };
  };
  light = {
    imports = [ ./base.nix ];
    config = {
      theme = {
        enable = true;
        color = "light";
      };
    };
  };
}
