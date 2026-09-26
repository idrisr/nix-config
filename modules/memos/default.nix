{ config
, lib
, ...
}:
with lib;
let
  cfg = config.my.memos;
in
{
  options.my.memos.enable = mkOption {
    default = false;
    type = types.bool;
    description = lib.mdDoc "enable Memos note-taking service";
  };

  config = mkIf cfg.enable {
    services.memos = {
      enable = true;
      openFirewall = true;
    };
  };
}
