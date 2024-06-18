{
  config.modules.system.services = {
    nextcloud.enable = true;
    mailserver.enable = true;
    vaultwarden.enable = true;
    forgejo.enable = false; #CHANGEME
    searxng.enable = true;
    reposilite.enable = false;
    invidious.enable = false; #CHANGEME
    suwayomi-server.enable = false; #CHANGEME
    adguard.enable = true;
    netdata.enable = false; #CHANGEME
    authelia.enable = true;
    jitsi-meet.enable = true;

    homelab = {
      homepage.enable = true;
    };

    social = {
      mastodon.enable = false; #CHANGEME
      matrix.enable = false;
    };

    # bincache = {
    #   harmonia.enable = true;
    # };

    networking = {
      # headscale.enable = true;
      wireguard.enable = true;
    };

    monitoring = {
      grafana.enable = false; #CHANGEME
      prometheus.enable = false; #CHANGEME
      loki.enable = false;
      uptime-kuma.enable = false; #CHANGEME
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
