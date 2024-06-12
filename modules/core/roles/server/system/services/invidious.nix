{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce;

  domain = "yt.xilain.dev";
  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.invidious.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    services = {
      invidious = {
        enable = true;
        port = mkDefault 3333;
        domain = mkDefault "${domain}";
        settings = {
          https_only = false;
          default_user_preferences = {
            locale = "en-US";
            region = "CA";
            captions = ["Vietnamese" "English" "English (auto-generated)"];
            feed_menu = ["Subscriptions" "Playlists"];
            default_home = "Subscriptions";
            player_style = "youtube";
            quality = "dash";
            dark_mode = "auto";
          };
          database = {
            createLocally = mkForce true;
            port = mkDefault 5432;
            host = mkDefault "/run/postgresql";
          };
          db = {
            # host = mkForce "/run/postgresql";
            # port = mkForce "";
            dbname = mkForce "invidious";
            user = mkForce "invidious";
          };
        };
      };

      nginx.virtualHosts."${domain}" =
        {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.invidious.settings.port}/";
            proxyWebsockets = true;
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
