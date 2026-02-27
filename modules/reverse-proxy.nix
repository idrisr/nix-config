{ config, lib, ... }:
let
  cfg = config.my.reverseProxy;
  certName = "reverse-proxy";
  baseHost =
    if cfg.subdomain == "" then cfg.domain else "${cfg.subdomain}.${cfg.domain}";
  fullDomain = name: "${name}.${baseHost}";
  vhostToNginx = name: vcfg:
    lib.nameValuePair (fullDomain name) {
      forceSSL = true;
      sslCertificate = cfg.certPaths.sslCertificate;
      sslCertificateKey = cfg.certPaths.sslCertificateKey;
      locations."/" = {
        proxyPass = vcfg.target;
        proxyWebsockets = true;
      };
    };
in
{
  options.my.reverseProxy = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc "Enable nginx reverse proxy with host-based routing";
    };

    domain = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "Base domain (e.g. example.com).";
    };

    subdomain = lib.mkOption {
      default = "lan";
      type = lib.types.str;
      description = lib.mdDoc "Prefix used for LAN hosts (e.g. lan → *.lan.example.com). Set to empty string to use apex wildcard.";
    };

    hosts = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (lib.types.submodule ({ ... }: {
        options.target = lib.mkOption {
          type = lib.types.str;
          description = lib.mdDoc "Upstream URL, e.g. http://127.0.0.1:3001";
        };
      }));
      description = lib.mdDoc "Virtual hosts keyed by subdomain (without subdomain/domain).";
    };

    acme = {
      email = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "ACME contact email.";
      };

        dnsProvider = lib.mkOption {
          default = "namecheap";
          type = lib.types.str;
          description = lib.mdDoc "lego DNS provider name.";
        };

      credentialFiles = lib.mkOption {
        type = lib.types.attrsOf lib.types.path;
        description = lib.mdDoc "Environment files for the ACME DNS provider, keys must end with _FILE (e.g. NAMECHEAP_API_USER_FILE / NAMECHEAP_API_KEY_FILE).";
      };
    };

    certPaths = lib.mkOption {
      type = lib.types.submodule {
        options = {
          sslCertificate = lib.mkOption {
            type = lib.types.path;
            description = lib.mdDoc "Path to fullchain certificate file.";
          };
          sslCertificateKey = lib.mkOption {
            type = lib.types.path;
            description = lib.mdDoc "Path to private key file.";
          };
        };
      };
      description = lib.mdDoc "Static cert/key paths. When set, ACME issuance is disabled and these files must be provided manually.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.certPaths != null || (cfg.acme.email or null) != null;
        message = "Provide either certPaths or ACME settings.";
      }
    ];

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = lib.mapAttrs' vhostToNginx cfg.hosts;
    };

    security.acme = lib.mkIf (cfg.certPaths == null) {
      acceptTerms = true;
      defaults.email = cfg.acme.email;
      certs.${certName} = {
        domain = "*.${baseHost}";
        extraDomainNames = [ baseHost ];
        dnsProvider = cfg.acme.dnsProvider;
        credentialFiles = cfg.acme.credentialFiles;
        group = "nginx";
        reloadServices = [ "nginx.service" ];
      };
    };
  };
}
