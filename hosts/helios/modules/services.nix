{
  config.modules.system.services = {
    nextcloud.enable = false; # changeme
    mailserver.enable = false; # changeme
    vaultwarden.enable = true;
    forgejo.enable = false; # changeme
    searxng.enable = true;
    reposilite.enable = false;
    invidious.enable = false; # changeme
    suwayomi-server.enable = false; # changeme
    adguard.enable = false; # changeme
    netdata.enable = false; # changeme
    authelia.enable = true;

    homelab = {
      homepage.enable = false; # changeme
    };

    social = {
      mastodon.enable = false; # changeme
      matrix.enable = false;
    };

    # bincache = {
    #   harmonia.enable = true;
    # };

    networking = {
      # headscale.enable = true;
      wireguard.enable = false; # changeme
    };

    monitoring = {
      grafana.enable = false; # changeme
      prometheus.enable = false; # changeme
      loki.enable = false;
      uptime-kuma.enable = false; # changeme
    };

    database = {
      mysql.enable = false;
      mongodb.enable = false;
      redis.enable = true;
      postgresql.enable = true;
      garage.enable = true;
    };
  };
}
