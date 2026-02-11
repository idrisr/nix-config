{ inputs, ... }:
{
  imports = [
    inputs.opencode.nixosModules.x86_64-linux.opencode
  ];

  config = {
    services.opencode = {
      enable = false;
      host = "0.0.0.0";
      port = 4444;
      openFirewall = true;
    };
  };
}
