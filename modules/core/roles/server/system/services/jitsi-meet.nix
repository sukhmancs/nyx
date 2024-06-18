{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  domain = "meet.xilain.dev";

  sys = config.modules.system;
  cfg = sys.services;
  inherit (cfg.jitsi-meet.settings) port host;
in {
  config = mkIf cfg.jitsi-meet.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    networking.firewall.allowedTCPPorts = [80 443];

    services = {
      jitsi-meet = {
        enable = true;
        hostName = "meet.xilain.dev";
        config = {
          enableWelcomePage = false;
          #   enableInsecureRoomNameWarning = true;
          #   fileRecordingsEnabled = false;
          #   liveStreamingEnabled = false;
          prejoinPageEnabled = true;
          defaultLang = "en";
        };
        interfaceConfig = {
          SHOW_JITSI_WATERMARK = false;
          SHOW_WATERMARK_FOR_GUESTS = false;
        };
      };
      jitsi-videobridge.openFirewall = true;

      nginx.virtualHosts.${domain} =
        {
          locations."/" = {
            # TODO: the port is not customizable in the upstream service, PR nixpkgs
            proxyPass = "http://${host}:${toString port}";
            proxyWebsockets = true;
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
