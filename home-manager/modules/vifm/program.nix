{ config, lib, ... }:
with lib;
let
  cfg = config.programs.vifm;
  configPath = "${config.xdg.configHome}/vifm/vifmrc";
in {
  options = {
    programs.vifm = {
      marks = mkOption {
        type = with types; attrs;
        default = { };
        example = {
          b = "~/books";
          d = "~/documents";
        };
        description = ''
          list of marks in form "<mark name>=<directory>"
        '';
      };

      viewer = mkOption {
        type = types.derivation;
        # type = types.package;
        default = null;
        description = ''
          attribute set of anything
        '';
      };

      opts = mkOption {
        type = with types; attrs;
        default = { };
        example = {
          scrolloff = 4;
          syscalls = true;
          undolevels = 100;
        };
        description = ''
          attribute set of anything
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home = let
      f = k: v:
        (if (isBool v) then
          if v then "set ${k}" else "set no${k}"
        else
          "set ${k}=${toString v}");
      g = k: v: "mark ${k} ${v}";
      marks = concatLines (attrsets.mapAttrsToList g cfg.marks);
      opts = concatLines (attrsets.mapAttrsToList f cfg.opts);
    in mkMerge [
      { packages = [ cfg.package ]; }
      (mkIf (cfg.marks != { } || marks != { } || opts != { }) {
        file."${configPath}".text =
          concatStringsSep "\n" [ marks opts cfg.extraConfig ];
        sessionVariables."VIFM" = configPath;
      })
    ];
  };
}
