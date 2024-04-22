{ pkgs, ... }:
let configSubDir = "vifm";
in {
  config = {
    xdg.configFile = {
      "${configSubDir}/vifmrc" = { text = builtins.readFile ./vifmrc; };
      "${configSubDir}/scripts/cleaner" = {
        text = builtins.readFile ./scripts/cleaner;
        executable = true;
      };
      "${configSubDir}/scripts/scope" = {
        text = builtins.readFile ./scripts/scope;
        executable = true;
      };
    };
    home.packages = with pkgs; [ vifm-full libheif ];
  };
}
