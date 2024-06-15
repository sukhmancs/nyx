{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.age) secrets;

  domain = "manga.xilain.dev";
  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.suwayomi-server.settings) port host;
in {
  config = mkIf cfg.suwayomi-server.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    services = {
      suwayomi-server = {
        enable = true;

        openFirewall = true;

        settings = {
          server = {
            ip = host;
            port = port;
            basicAuthEnabled = true;
            basicAuthUsername = "suwayomi";

            # NOTE: this is not a real upstream option
            basicAuthPasswordFile = secrets.suwayomi-server-password.path;
            autoDownloadNewChapters = false;
            maxSourcesInParallel = 6;
            extensionRepos = [
              "https://raw.githubusercontent.com/ThePBone/tachiyomi-extensions-revived/repo/index.min.json"
              "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
            ];
            settings = {
              server.webUIEnabled = true;
              server.initialOpenInBrowserEnabled = false;
              server.systemTrayEnabled = false;
              server.socksProxyEnabled = false;
              server.webUIFlavor = "WebUI";
              server.webUIInterface = "browser";
              server.webUIChannel = "stable"; # "bundled" (the version bundled with the server release), "stable" or "preview" - the webUI version that should be used
              server.webUIUpdateCheckInterval = 23;
              server.globalUpdateInterval = 12;
              server.updateMangas = false;
            };
          };
        };
      };

      nginx.virtualHosts."manga.xilain.dev" =
        {
          locations."/" = {
            proxyPass = "http://${host}:${toString port}";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
