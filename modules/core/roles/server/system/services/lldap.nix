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
          ldap_base_dn = "dc=xilain,dc=dev";
          # key_file = secrets.lldap_private_key.path;
        };
        environment = {
          #TODO: use secrets
          # LLDAP_JWT_SECRET = "supersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkey";
          # LLDAP_LDAP_USER_PASS = "supersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkey2323$autA";
          # LLDAP_JWT_SECRET_FILE = secrets.lldap_jwt_secret.path;
          # LLDAP_LDAP_USER_PASS_FILE = secrets.lldap_user_pass.path;
          LLDAP_JWT_SECRET = "na<CP/B&qK?:cmDl>dk>IoHKjB2c#l@M";
          LLDAP_KEY_SEED = "IiB&IBZH6%kr-IUIoz62^Z@XQCS#s&!d";
          LLDAP_LDAP_USER_DN = "admin";
          LLDAP_LDAP_USER_PASS = "password";
          # LLDAP_LDAP_USER_EMAIL = "admin@changeme.com";
          LLDAP_FORCE_LDAP_USER_PASS_RESET = "false";
        };
      };

      nginx.virtualHosts.${domain} =
        {
          locations."/" = {
            # TODO: the port is not customizable in the upstream service, PR nixpkgs
            proxyPass = "http://${host}:${toString port}";
            proxyWebsockets = true;
            # extraConfig = "proxy_pass_header Authorization;";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };

    systemd.services.lldap.serviceConfig.SupplementaryGroups = ["lldap-secrets"];
  };
}
