#
# Override the default settings
#
{lib, ...}: {
  config = {
    services.resolved.enable = lib.mkForce false; # use adguardhome for dns
    networking = {
      networkmanager.dns = lib.mkForce "none";
      nameservers = ["102.209.85.226"]; # adguardhome dns server
    };
  };
}
