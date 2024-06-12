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
  # imports = [
  #   ./homepage.nix
  # ];
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
    modules.system.services.homelab = {
      homepage = {
        setting = {
          title = "Xi's dashboard";
          favicon = "https://jnsgr.uk/favicon.ico";
          headerStyle = "clean"; # "boxedWidgets";
          layout = {
            Services = {
              style = "row";
              columns = 4;
            };
            Multimedia = {
              style = "row";
              columns = 4;
            };
            Developer = {
              style = "row";
              columns = 4;
            };
          };
          hideVersion = true;
          quicklaunch = {
            provider = "custom";
            url = "https://search.xilain.dev/search?q=";
            target = "_blank";
            suggestionUrl = "https://ac.ecosia.org/autocomplete?type=list&q=";
          };
        };
        widgets = [
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
          {
            resources = {
              label = "system";
              cpu = true;
              memory = true;
            };
          }
          {
            resources = {
              label = "storage";
              disk = ["/data"];
            };
          }
          {
            openmeteo = {
              label = "Bristol";
              timezone = "America/Toronto";
              latitude = "{{HOMEPAGE_VAR_LATITUDE}}";
              longitude = "{{HOMEPAGE_VAR_LONGITUDE}}";
              units = "metric";
            };
          }
        ];
        services = [
          {
            Services = [
              {
                Nextcloud = {
                  href = "https://cloud.${domain}";
                  icon = "nextcloud";
                };
              }
              {
                SearX = {
                  href = "https://search.${domain}";
                  icon = "searxng";
                };
              }
              {
                Vaultwarden = {
                  href = "https://vault.${domain}";
                  icon = "vaultwarden";
                };
              }
              {
                Forgejo = {
                  href = "https://git.${domain}";
                  icon = "forgejo";
                };
              }
              {
                Mastodon = {
                  href = "https://social.${domain}";
                  icon = "mastodon";
                };
              }
              {
                RepoSilite = {
                  href = "https://repo.${domain}";
                  icon = "reposilite";
                };
              }
              {
                Mail = {
                  href = "https://webmail.${domain}";
                  icon = "mailfence";
                };
              }
              {
                Invidious = {
                  href = "https://yt.${domain}";
                  icon = "invidious";
                };
              }
              # {
              #   Gitea = {
              #     href = "https://gitea.${domain}";
              #     icon = "gitea";
              #   };
              # }
              # {
              #   Miniflux = {
              #     href = "https://rss.${domain}";
              #     icon = "miniflux";
              #   };
              # }
              # {
              #   MinIO = {
              #     href = "https://minio-console.${domain}";
              #     icon = "minio";
              #   };
              # }
            ];
          }
          {
            Utilities = [
              # {
              #   Traefik = {
              #     href = "https://traefik.${domain}";
              #     icon = "traefik";
              #   };
              # }
              # {
              #   Blocky = {
              #     href = "https://blocky.${domain}";
              #     icon = "blocky";
              #   };
              # }
              # {
              #   LLDAP = {
              #     href = "https://ldap.${domain}";
              #   };
              # }
              # {
              #   Authelia = {
              #     href = "https://auth.${domain}";
              #     icon = "authelia";
              #   };
              # }
            ];
          }
          # {
          #   Multimedia = [
          #     {
          #       Jellyfin = {
          #         icon = "jellyfin";
          #         href = "https://jellyfin.${domain}";
          #       };
          #     }
          #     {
          #       Sonarr = {
          #         icon = "sonarr";
          #         href = "https://sonarr.${domain}";
          #       };
          #     }
          #     {
          #       Radarr = {
          #         icon = "radarr";
          #         href = "https://radarr.${domain}";
          #       };
          #     }
          #     {
          #       Bazarr = {
          #         icon = "bazarr";
          #         href = "https://bazarr.${domain}";
          #       };
          #     }
          #     {
          #       Prowlarr = {
          #         icon = "prowlarr";
          #         href = "https://prowlarr.${domain}";
          #       };
          #     }
          #     {
          #       Readarr = {
          #         icon = "readarr";
          #         href = "https://readarr.${domain}";
          #       };
          #     }
          #     {
          #       Deluge = {
          #         icon = "deluge";
          #         href = "https://deluge.${domain}";
          #       };
          #     }
          #   ];
          # }
          {
            Monitoring = [
              {
                Grafana = {
                  href = "https://dash.${domain}";
                  icon = "grafana";
                };
              }
              {
                UptimeKuma = {
                  href = "https://up.${domain}";
                  icon = "uptime-kuma";
                };
              }
              # {
              #   Netdata = {
              #     href = "https://netdata.${domain}";
              #     icon = "netdata";
              #   };
              # }
              # {
              #   Prometheus = {
              #     href = "https://prometheus.${domain}";
              #     icon = "prometheus";
              #   };
              # }
            ];
          }
        ];
        bookmarks = [
          {
            Developer = [
              {
                Github = [
                  {
                    icon = "si-github";
                    href = "https://github.com/";
                  }
                ];
              }
              {
                "Nixos Search" = [
                  {
                    icon = "si-nixos";
                    href = "https://search.nixos.org/packages";
                  }
                ];
              }
              {
                "Nixos Wiki" = [
                  {
                    icon = "si-nixos";
                    href = "https://nixos.wiki/";
                  }
                ];
              }
            ];
          }
        ];
      };
    };

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
