#
# Override the default settings
#
{lib, ...}: {
  config = {
    services.resolved.enable = lib.mkForce false; # use adguardhome for dns
    networking = {
      networkmanager.dns = lib.mkForce "none";
      nameservers = ["dns.xilain.dev"]; # adguardhome dns server
    };
  };
}
