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
        port = mkDefault "${toString cfg.invidious.settings.port}";
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
          db = {
            host = mkForce "/run/postgresql";
            # port = "5432";
            dbname = mkForce "invidious";
            user = mkForce "invidious";
            password = mkForce "";
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
