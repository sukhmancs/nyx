{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  format = pkgs.formats.yaml {};
  configDir = "/var/lib/homepage-dashboard";

  domain = "xilain.dev";

  sys = config.modules.system;
  cfg = sys.services.homelab;
in {
  config = mkIf cfg.homepage.enable {
    modules.system.services.homelab = {
      homepage.settings = {
        settings = {
          title = "Xi's dashboard";
          favicon = "https://jnsgr.uk/favicon.ico";
          headerStyle = "clean"; # "boxedWidgets";
          # layout = {
          #   Services = {
          #     style = "row";
          #     columns = 4;
          #   };
          #   Multimedia = {
          #     style = "row";
          #     columns = 4;
          #   };
          #   Developer = {
          #     style = "row";
          #     columns = 4;
          #   };
          # };
          hideVersion = true;
        };
        widgets = [
          {
            logo = {
              icon = "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/I_Love_New_York.svg/1101px-I_Love_New_York.svg.png"; # optional
            };
          }
          {
            search = {
              provider = "custom";
              url = "https://search.xilain.dev/search?q=";
              target = "_blank";
              suggestionUrl = "https://ac.ecosia.org/autocomplete?type=list&q="; # Optional
              showSearchSuggestions = true;
            };
          }
          {
            resources = {
              label = "system";
              expanded = true;
              cpu = true;
              memory = true;
              uptime = true;
            };
          }
          {
            resources = {
              label = "storage";
              expanded = true;
              disk = ["/"];
            };
          }
          {
            openmeteo = {
              label = "weather";
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
      virtualHosts."home.${domain}" =
        {
          locations."/".proxyPass = "http://${toString cfg.homepage.settings.host}:${toString cfg.homepage.settings.port}";

          quic = true;
        }
        // lib.sslTemplate; # Enable SSL
    };

    services.homepage-dashboard.enable = true;
    systemd.services.homepage-dashboard = {
      preStart = ''
        ln -sf ${format.generate "settings.yaml" cfg.homepage.settings.settings} ${configDir}/settings.yaml
        ln -sf ${format.generate "services.yaml" cfg.homepage.settings.services} ${configDir}/services.yaml
        ln -sf ${format.generate "widgets.yaml" cfg.homepage.settings.widgets} ${configDir}/widgets.yaml
        ln -sf ${format.generate "bookmarks.yaml" cfg.homepage.settings.bookmarks} ${configDir}/bookmarks.yaml
      '';
    };
  };
}
