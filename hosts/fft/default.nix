{ pkgs, lib, config, ... }:
{
  options = { };

  imports = [ ./hardware-fft.nix ];

  config = {
    my.base.enable = true;
    my.anki.enable = true;
    my.jellyfin.enable = true;
    my.borgrepo.enable = true;
    my.servernode.enable = true;
    my.redmine.enable = true;
    my.reverseProxy = {
      enable = true;
      domain = "idrisraja.com";
      subdomain = "";
      # Manual cert mode: place your fullchain/key at these paths.
      certPaths = {
        sslCertificate = "/var/lib/reverse-proxy/manual/fullchain.pem";
        sslCertificateKey = "/var/lib/reverse-proxy/manual/key.pem";
      };
      hosts = {
        redmine.target = "http://127.0.0.1:3001";
        jellyfin.target = "http://127.0.0.1:8096";
        immich.target = "http://127.0.0.1:2283";
        adguard.target = "http://127.0.0.1:3000";
      };
    };
    environment.systemPackages = lib.mkAfter (with pkgs; [ atuin binutils ]);
    networking.adblocker.enable = true;
  };
}
