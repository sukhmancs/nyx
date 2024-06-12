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
  cfg = sys.services.homelab;
in {
  imports = [
    ./homepage.nix
  ];
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

  config = mkIf cfg.homepage.enable {
    services.nginx = {
      enable = true;
      virtualHosts."${domain}" =
        {
          locations."/".proxyPass = "http://${toString cfg.homepage.settings.host}:${toString cfg.homepage.settings.port}";

          quic = true;
        }
        // lib.sslTemplate; # Enable SSL
    };

    services.homepage-dashboard.enable = true;
    systemd.services.homepage-dashboard = {
      preStart = ''
        ln -sf ${format.generate "settings.yaml" cfg.homepage.setting} ${configDir}/settings.yaml
        ln -sf ${format.generate "services.yaml" cfg.homepage.services} ${configDir}/services.yaml
        ln -sf ${format.generate "widgets.yaml" cfg.homepage.widgets} ${configDir}/widgets.yaml
        ln -sf ${format.generate "bookmarks.yaml" cfg.homepage.bookmarks} ${configDir}/bookmarks.yaml
      '';
    };
  };
}
