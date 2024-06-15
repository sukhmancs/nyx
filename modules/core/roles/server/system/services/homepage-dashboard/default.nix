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

  inherit (cfg.homepage.settings) port host;
in {
  config = mkIf cfg.homepage.enable {
    modules.system.services.homelab = {
      homepage.settings = {
        settings = {
          title = "Xi's dashboard";
          favicon = "https://jnsgr.uk/favicon.ico";
          # This will make the page less responsive. You are warned.
          background = {
            image = "https://images.unsplash.com/photo-1502790671504-542ad42d5189?auto=format&fit=crop&w=2560&q=80";
            blur = "sm"; # sm, "", md, xl... see https://tailwindcss.com/docs/backdrop-blur
            saturate = 50; # 0, 50, 100... see https://tailwindcss.com/docs/backdrop-saturate
            brightness = 50; # 0, 50, 75... see https://tailwindcss.com/docs/backdrop-brightness
            opacity = 50; # 0-100
          };
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
                  siteMonitor = "https://cloud.${domain}";
                };
              }
              {
                SearXNG = {
                  href = "https://search.${domain}";
                  icon = "searxng";
                  siteMonitor = "https://search.${domain}";
                };
              }
              {
                Vaultwarden = {
                  href = "https://vault.${domain}";
                  icon = "vaultwarden";
                  siteMonitor = "https://vault.${domain}";
                };
              }
              {
                Forgejo = {
                  href = "https://git.${domain}";
                  icon = "forgejo";
                  siteMonitor = "https://git.${domain}";
                };
              }
              {
                Mastodon = {
                  href = "https://social.${domain}";
                  icon = "mastodon";
                  siteMonitor = "https://social.${domain}";
                };
              }
              {
                RepoSilite = {
                  href = "https://repo.${domain}";
                  icon = "mdi-cached";
                  siteMonitor = "https://repo.${domain}";
                };
              }
              {
                Mail = {
                  href = "https://webmail.${domain}";
                  icon = "roundcube";
                  siteMonitor = "https://webmail.${domain}";
                };
              }
              {
                Invidious = {
                  href = "https://yt.${domain}";
                  icon = "invidious";
                  siteMonitor = "https://yt.${domain}";
                };
              }
              {
                Suwayomi = {
                  href = "https://manga.${domain}";
                  icon = "https://raw.githubusercontent.com/Suwayomi/Suwayomi-Server/master/server/src/main/resources/icon/faviconlogo.png";
                  siteMonitor = "https://manga.${domain}";
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
              {
                Nginx = {
                  href = "https://${domain}";
                  icon = "nginx-proxy-manager";
                  siteMonitor = "https://${domain}";
                };
              }
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
                  siteMonitor = "https://dash.${domain}";
                };
              }
              {
                "Uptime Kuma" = {
                  href = "https://up.${domain}";
                  icon = "uptime-kuma";
                  siteMonitor = "https://up.${domain}";
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
          locations."/".proxyPass = "http://${host}:${toString port}";

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
