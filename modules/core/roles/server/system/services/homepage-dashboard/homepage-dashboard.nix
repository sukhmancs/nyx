{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  # cfg = config.homelab.homepage;
  # homepage = config.services.homepage-dashboard;
  format = pkgs.formats.yaml {};
  configDir = "/var/lib/homepage-dashboard";

  domain = "home.xilain.dev";

  sys = config.modules.system;
  cfg = sys.services;
in {
  # options.homelab.homepage = with lib; {
  #   enable = mkEnableOption "homepage";
  #   settings = mkOption {
  #     type = types.attrs;
  #     default = {};
  #   };
  #   services = mkOption {
  #     type = types.listOf types.attrs;
  #     default = [];
  #   };
  #   widgets = mkOption {
  #     type = types.listOf types.attrs;
  #     default = [];
  #   };
  #   bookmarks = mkOption {
  #     type = types.listOf types.attrs;
  #     default = [];
  #   };
  # };

  config = mkIf cfg.homelab.enable {
    services.nginx = {
      enable = true;
      virtualHosts."${domain}" =
        {
          locations."/".proxyPass = "http://${toString cfg.homelab.settings.host}:${toString cfg.homelab.settings.Port}";

          quic = true;
        }
        // lib.sslTemplate; # Enable SSL
    };

    services.homepage-dashboard.enable = true;
    systemd.services.homepage-dashboard = {
      preStart = ''
        ln -sf ${format.generate "settings.yaml" cfg.homelab.setting} ${configDir}/settings.yaml
        ln -sf ${format.generate "services.yaml" cfg.homelab.services} ${configDir}/services.yaml
        ln -sf ${format.generate "widgets.yaml" cfg.homelab.widgets} ${configDir}/widgets.yaml
        ln -sf ${format.generate "bookmarks.yaml" cfg.homelab.bookmarks} ${configDir}/bookmarks.yaml
      '';
    };
  };
}
