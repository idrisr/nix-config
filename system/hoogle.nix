{
  config = {
    services = {
      hoogle = {
        enable = true;
        packages = hp:
          with hp; [
            pdf-toolbox-content
            pdf-toolbox-core
            pdf-toolbox-document
            brick
          ];
      };
    };
  };
  options = { };
  imports = [ ];
}
