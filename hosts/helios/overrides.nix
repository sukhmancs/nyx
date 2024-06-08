{lib, ...}: {
  config = {
    services.qemuGuest.enable = lib.mkForce true;

    networking = {
      defaultGateway = "102.209.85.225";
      defaultGateway6 = {
        address = "";
        interface = "eth0";
      };
      dhcpcd.enable = lib.mkForce false;
      usePredictableInterfaceNames = lib.mkForce false;
      interfaces = {
        eth0 = {
          ipv4.addresses = [
            {
              address = "102.209.85.254";
              prefixLength = 27;
            }
          ];
          ipv6.addresses = [
            {
              address = "fe80::be24:11ff:fe16:a408";
              prefixLength = 64;
            }
          ];
          ipv4.routes = [
            {
              address = "102.209.85.225";
              prefixLength = 32;
            }
          ];
          ipv6.routes = [
            {
              address = "";
              prefixLength = 128;
            }
          ];
        };
      };
    };
    services.udev.extraRules = ''
      ATTR{address}=="bc:24:11:16:a4:08", NAME="eth0"

    '';
  };
}
