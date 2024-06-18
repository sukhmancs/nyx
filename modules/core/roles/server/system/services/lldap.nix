{
  config,
  lib,
  ...
}: let
  inherit (config.age) secrets;

  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
  domain = "ldap.xilain.dev";

  inherit (cfg.ldap.settings) port host;
in {
  config = mkIf (cfg.ldap.enable
    || cfg.authelia.enable) {
    modules.system.services = {
      nginx.enable = true;
    };

    services = {
      lldap = {
        enable = true;
        settings = {
          http_url = "https://${domain}";
          ldap_base_dn = "dc=xilain,dc=xyz";
          key_file = secrets.lldap_private_key.path;
        };
        environment = {
          LLDAP_JWT_SECRET_FILE = secrets.lldap_jwt_secret.path;
          LLDAP_LDAP_USER_PASS_FILE = secrets.lldap_user_pass.path;
        };
      };

      nginx.virtualHosts.${domain} =
        {
          locations."/" = {
            # TODO: the port is not customizable in the upstream service, PR nixpkgs
            proxyPass = "http://${host}:${toString port}";
            proxyWebsockets = true;
            extraConfig = "proxy_pass_header Authorization;";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };

    # systemd.services.lldap.serviceConfig.SupplementaryGroups = ["lldap-secrets"];
  };
}
