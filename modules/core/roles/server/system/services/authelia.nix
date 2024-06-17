{
  config,
  pkgs,
  lib,
  ...
}: let
  authelia = config.services.authelia.instances.main;
  redis = config.services.redis.servers."";
  autheliaUrl = "http://${authelia.settings.server.host}:${builtins.toString authelia.settings.server.port}";
  inherit (lib) mkIf mkDefault;
  inherit (config.age) secrets;

  cfg = config.modules.system.services;

  inherit (cfg.authelia.settings) host port;
in {
  config = mkIf cfg.authelia.enable {
    # Open Port in Firewall
    networking.firewall.allowedTCPPorts = [port];

    modules.system.services = {
      nginx.enable = true;
      database = {
        redis.enable = true;
        postgresql.enable = true;
      };
    };
    environment.systemPackages = [
      pkgs.authelia
    ];

    users.users."notashelf".extraGroups = ["authelia"];
    users.users."${authelia.user}".extraGroups = ["redis" "sendgrid"];

    services = {
      authelia.instances.main = {
        enable = true;
        secrets = {
          jwtSecretFile = "${pkgs.writeText "jwtSecretFile" "supersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkey"}";
          storageEncryptionKeyFile = "${pkgs.writeText "storageEncryptionKeyFile" "supersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkey"}";
          sessionSecretFile = "${pkgs.writeText "sessionSecretFile" "supersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkeysupersecretkey"}";
          # jwtSecretFile = config.age.secrets.authelia_jwt_secret.path;
          # oidcHmacSecretFile = "${pkgs.writeText "oidSecretFile" "supersecretkey"}";
          # oidcIssuerPrivateKeyFile = "${pkgs.writeText "oidcissuerSecretFile" "supersecretkey"}";
          # sessionSecretFile = config.age.secrets.authelia_session_secret.path;
          # storageEncryptionKeyFile = config.age.secrets.authelia_storage_encryption_key.path;
        };
        # environmentVariables = {
        #   # AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = config.age.secrets.ldap_password.path;
        #   AUTHELIA_NOTIFIER_SMTP_PASSWORD_FILE = secrets.mailserver-vaultwarden-secret.path;
        #   # AUTHELIA_STORAGE_MYSQL_PASSWORD_FILE = config.age.secrets.authelia_mysql_password.path;
        # };
        #   settingsFiles = [config.age.secrets.authelia_secret_config.path];
        settings = {
          theme = "dark";
          # default_redirection_url = "https://xilain.dev";
          default_2fa_method = "totp";
          server = {
            host = mkDefault host;
            port = mkDefault port;
          };
          log.level = "info";
          # totp.issuer = "authelia.com";
          session = {
            domain = "xilain.dev";
            # redis.host = "/run/redis-authelia-main/redis.sock";
            redis = {
              host = redis.unixSocket;
              port = 0;
              database_index = 0;
            };
          };
          regulation = {
            max_retries = 3;
            find_time = 120;
            ban_time = 300;
          };
          authentication_backend = {
            file = {
              # CHANGEME
              path = "/var/lib/authelia-main/users_database.yml";
            };
            # password_reset.disable = false;
            # refresh_interval = "1m";
            # ldap = {
            #   implementation = "custom";
            #   url = "ldap://localhost:3890";
            #   timeout = "5m";
            #   start_tls = false;
            #   base_dn = "dc=longerhv,dc=xyz";
            #   username_attribute = "uid";
            #   additional_users_dn = "ou=people";
            #   users_filter = "(&({username_attribute}={input})(objectClass=person))";
            #   additional_groups_dn = "ou=groups";
            #   groups_filter = "(member={dn})";
            #   group_name_attribute = "cn";
            #   mail_attribute = "mail";
            #   display_name_attribute = "displayName";
            #   user = "uid=admin,ou=people,dc=longerhv,dc=xyz";
            # };
          };
          access_control = {
            default_policy = "deny";
            # networks = [
            #   {
            #     name = "localhost";
            #     networks = ["127.0.0.1/32"];
            #   }
            #   {
            #     name = "internal";
            #     networks = [
            #       "10.100.0.0/8"
            #       "172.16.0.0/12"
            #       "192.168.0.0/16"
            #       "102.209.85.226/27"
            #     ];
            #   }
            # ];
            rules = [
              {
                domain = ["auth.xilain.dev"];
                policy = "bypass";
                # networks = "localhost";
              }
              {
                domain = ["*.xilain.dev"];
                policy = "one_factor";
                # networks = "internal";
                # subject = [
                #   "group:admin"
                # ];
              }
            ];
          };
          storage = {
            local = {
              path = "/var/lib/authelia-main/db.sqlite3";
            };
            # postgres = {
            #   host = "/run/postgresqld/postgresqld.sock";
            #   database = "authelia";
            #   username = "authelia";
            #   password = "changeme"; # CHANGEME
            # };
          };
          notifier = {
            disable_startup_check = false;
            filesystem = {
              filename = "/var/lib/authelia-main/notification.txt";
            };
            # smtp = {
            #   host = "mail.xilain.dev";
            #   port = 465;
            #   username = "xilain";
            #   sender = "vaultwarden@xilain.dev";
            # };
          };
        };
      };

      nginx.virtualHosts."auth.xilain.dev" =
        {
          # enableACME = true;
          forceSSL = true;
          # acmeRoot = null;

          # locations."/" = {
          #   proxyPass = autheliaUrl;
          #   proxyWebsockets = true;
          # };
          # quic = true;
          extraConfig = ''
              location / {
                set $upstream_authelia http://127.0.0.1:9092;
                proxy_pass $upstream_authelia;
                client_body_buffer_size 128k;

                #Timeout if the real server is dead
                proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

                # Advanced Proxy Config
                send_timeout 5m;
                proxy_read_timeout 360;
                proxy_send_timeout 360;
                proxy_connect_timeout 360;

                # Basic Proxy Config
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header X-Forwarded-Uri $request_uri;
                proxy_set_header X-Forwarded-Ssl on;
                proxy_redirect  http://  $scheme://;
                proxy_http_version 1.1;
                proxy_set_header Connection "";
                proxy_cache_bypass $cookie_session;
                proxy_no_cache $cookie_session;
                proxy_buffers 64 256k;

                # If behind reverse proxy, forwards the correct IP
                set_real_ip_from 10.0.0.0/8;
                set_real_ip_from 172.0.0.0/8;
                set_real_ip_from 192.168.0.0/16;
                set_real_ip_from fc00::/7;
                real_ip_header X-Forwarded-For;
                real_ip_recursive on;
            }
          '';
        }
        // lib.sslTemplate;
    };

    # systemd.services.authelia.after = ["lldap.service"];
  };
}
