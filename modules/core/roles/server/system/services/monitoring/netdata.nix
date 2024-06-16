{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkForce;

  domain = "netdata.xilain.dev";
  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.netdata.settings) port host;
in {
  config = mkIf cfg.netdata.enable {
    modules.system.services = {
      nginx.enable = true;
    };
    services = {
      netdata = {
        enable = true;
        config.global = {
          "update every" = "15";
        };
      };

      nginx.virtualHosts."${domain}" =
        {
          locations."/" = {
            proxyPass = "http://${host}:${toString port}";
            # proxyWebsockets = true;
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
