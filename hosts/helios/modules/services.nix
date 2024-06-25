{
  config.modules.system.services = {
    nextcloud.enable = true;
    mailserver.enable = false; #Change me
    vaultwarden.enable = true;
    forgejo.enable = false; #Change me
    searxng.enable = true;
    reposilite.enable = false;
    invidious.enable = false; #Change me
    suwayomi-server.enable = false; #Change me
    adguard.enable = true;
    netdata.enable = false; #Change me
    authelia.enable = true;
    jitsi-meet.enable = false; #FIXME: Remove jitsi-meet as i was unable to find a way for jitsi-meet to listen on different port other than 443. I am already serving my own website on that port.And that is where nginx is listening

    homelab = {
      homepage.enable = true;
    };

    social = {
      mastodon.enable = false; #Change me
      matrix.enable = false; #Change me
    };

    bincache = {
      harmonia.enable = false; #Change me
    };

    networking = {
      # headscale.enable = true;
      wireguard.enable = true;
    };

    monitoring = {
      grafana.enable = true;
      prometheus.enable = true;
      loki.enable = false;
      uptime-kuma.enable = true;
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
