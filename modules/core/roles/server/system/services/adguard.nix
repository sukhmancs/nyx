{
  lib,
  config,
  ...
}: let
  #   roleName = "adguard";
  #   roleEnabled = lib.elem roleName config.homelab.currentHost.roles;
  #   alias = "dns";
  #   aliasdefined = !(builtins.elem alias config.homelab.currentHost.dnsalias);
  #   cfg = config.services.adguardhome;
  # Function
  # Get Hosts IP
  #   hostsIps =
  #     lib.mapAttrsToList
  #     (
  #       name: host: {
  #         domain = name;
  #         answer = host.ipv4;
  #       }
  #     )
  #     config.homelab.hosts;
  #   # Function
  #   # Get Alias IP
  #   aliasIps =
  #     lib.flatten
  #     (
  #       lib.mapAttrsToList
  #       (
  #         name: host: let
  #           alias = lib.optionals (host.dnsalias != null) host.dnsalias;
  #         in
  #           map
  #           (entry: {
  #             domain = entry;
  #             answer = host.ipv4;
  #           })
  #           alias
  #       )
  #       config.homelab.hosts
  #     );
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;

  domain = "dns.xilain.dev";

  inherit (cfg.adguard.settings) port host;
in {
  config = mkIf cfg.adguard.enable {
    modules.system.services = {
      nginx.enable = true;
    };

    networking.firewall.allowedTCPPorts = [80 443];
    networking.firewall.allowedUDPPorts = [53];

    services = {
      adguardhome = {
        enable = true;
        mutableSettings = false;
        port = 3002;
        settings = {
          # bind_host = "0.0.0.0";
          # bind_port = 3002;
          # FIXME: temporary fix, MR is in progress https://github.com/NixOS/nixpkgs/issues/278601
          #   bind_port = 3002;
          http.address = "0.0.0.0:3002";
          schema_version = 20;
          dns = {
            ratelimit = 0;
            bind_hosts = ["0.0.0.0"];
            bootstrap_dns = [
              "9.9.9.10"
              "149.112.112.10"
              "2620:fe::10"
              "2620:fe::fe:10"
            ];
            upstream_dns = [
              "1.1.1.1"
              "1.0.0.1"
              "8.8.8.8"
              "8.8.4.4"
            ];
            #   rewrites = hostsIps ++ aliasIps;
          };
          filtering = {
            protection_enabled = true;
            filtering_enabled = true;

            parental_enabled = false; # Parental control-based DNS requests filtering.
            safe_search = {
              enabled = false; # Enforcing "Safe search" option for search engines, when possible.
            };
          };
          # The following notation uses map
          # to not have to manually create {enabled = true; url = "";} for every filter
          # This is, however, fully optional
          filters =
            map (url: {
              enabled = true;
              url = url;
            }) [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
            ];
        };
      };

      nginx.virtualHosts."${domain}" =
        {
          # Use wildcard domain
          useACMEHost = "xilain.dev";
          forceSSL = true;

          locations."/" = {
            extraConfig = ''
              proxy_pass http://127.0.0.1:3002;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };

          quic = true;
        }
        // lib.sslTemplate;
    };
  };
}
