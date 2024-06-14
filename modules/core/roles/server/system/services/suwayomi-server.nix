{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.suwayomi-server.settings) port host;
in {
  config = mkIf cfg.suwayomi-server.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    services.suwayomi-server = {
      enable = true;

      openFirewall = true;

      settings = {
        server = {
          ip = "${host}";
          port = port;
          #   basicAuthEnabled = true;
          #   basicAuthUsername = "suwayomi";

          #   # NOTE: this is not a real upstream option
          #   basicAuthPasswordFile = ./path/to/the/password/file;
          autoDownloadNewChapters = false;
          maxSourcesInParallel = 6;
          extensionRepos = [
            "https://raw.githubusercontent.com/ThePBone/tachiyomi-extensions-revived/repo/index.min.json"
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ];
          settings = {
            server.webUIEnabled = false;
            server.globalUpdateInterval = 12;
            server.updateMangas = false;
          };
        };

        nginx.virtualHosts. "manga.xilain.dev" =
          {
            locations."/" = {
              # TODO: the port is not customizable in the upstream service, PR nixpkgs
              proxyPass = "http://${host}:${toString port}";
            };

            quic = true;
          }
          // lib.sslTemplate;
      };
    };
  };
}
