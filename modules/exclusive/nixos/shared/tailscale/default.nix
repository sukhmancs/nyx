#
# Tailscale - Client Setup (Overide the flags for tailscale server setup)
#
{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) optionals concatLists;
  inherit (builtins) concatStringsSep;
  inherit (lib.modules) mkIf mkDefault;
  inherit (config.services) tailscale;

  endpoint = "https://hs.xilain.dev";
  operator = config.modules.system.mainUser;
  tags = ["tag:client"]; # default tag for all clients
  flags = concatLists [
    ["--ssh"]
    ["--authkeyfile:${config.age.secrets.tailscale-client.path}"]
    (optionals (endpoint != null) ["--login-server" "${endpoint}"])
    (optionals (operator != null) ["--operator ${operator}"])
    (optionals (tags != []) ["--advertise-tags" (concatStringsSep "," tags)])
  ];
in {
  imports = [./autoconnect.nix];
  config = mkIf config.services.tailscale.enable {
    # Allow all system users to use the `tailscale` command
    # by adding the package used by the tailscale service
    # to their PATH.
    environment.systemPackages = [tailscale.package];

    networking.firewall = {
      # Always allow traffic from the designated tailscale interface
      trustedInterfaces = ["${tailscale.interfaceName}"];
      checkReversePath = "loose";

      # Allow tailscale over UDP
      allowedUDPPorts = [tailscale.port];
    };

    boot.kernel.sysctl = {
      # Enable IP forwarding
      # required for Wireguard & Tailscale/Headscale subnet feature
      # Technically, not all hosts do need to be able to IP forward but this could potentially
      # come in handy when I need to turn a host into an exit node.
      # See:
      #  <https://tailscale.com/kb/1019/subnets/?tab=linux#step-1-install-the-tailscale-client>
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };

    users = {
      groups.tailscaled = {};
      users.tailscaled = {
        group = "tailscaled";
        isSystemUser = true;
      };
    };

    # Enable Tailscale, the inter-machine VPN service
    # with our Headscale coordination server.
    services.tailscale = {
      permitCertUid = "root";
      useRoutingFeatures = mkDefault "both";
      # TODO: these flags still need to be specified with `tailscale up`
      # for some reason
      extraUpFlags = flags;
    };

    # Ignore the default Tailscale interface for network.wait-online
    # this should generally mean faster boot, and the interface will
    # be "activated" once the auto-connect service is triggered.
    systemd.network.wait-online.ignoredInterfaces = ["${tailscale.interfaceName}"];
  };
}
