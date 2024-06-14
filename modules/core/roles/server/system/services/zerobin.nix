{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.zerobin.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    services = {
      zerobin = {
        enable = true;
        group = "zerobin";
        user = "zerobin";
        dataDir = "/var/lib/zerobin";
      };

      nginx.virtualHosts. "bin.xilain.dev" =
        {
          locations."/" = {
            # TODO: the port is not customizable in the upstream service, PR nixpkgs
            proxyPass = "http://127.0.0.1:${cfg.zerobin.settings.port}/";
            proxyWebsockets = true;
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
