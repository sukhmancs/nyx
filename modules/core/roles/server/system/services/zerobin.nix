{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  inherit (cfg.zerobin.settings) port host;
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
            proxyPass = "http://${host}:${toString port}";
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
