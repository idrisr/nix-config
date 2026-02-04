{ inputs, ... }:
{
  imports = [
    inputs.opencode.nixosModules.x86_64-linux.opencode
  ];

  config = {
    services.opencode = {
      enable = true;
      host = "localhost";
      port = 4444;
      openFirewall = false;
    };
  };
}
