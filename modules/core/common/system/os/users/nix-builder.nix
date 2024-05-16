{
  users = {
    groups.nix = {};

    users.nix-builder = {
      useDefaultShell = true;
      isSystemUser = true;
      createHome = true;
      group = "nix";
      home = "/var/tmp/nix-builder";
      openssh.authorizedKeys = {
        keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSz0b/FIpF3JdizQ9IpMzfVmcPPMcHcw/+vad0oFYoC david@nixos"]; # TODO(important): changeme - use different keys for each user. Also change the passphrase.
        # keyFiles = []; # TODO: can this be used with agenix?
      };
    };
  };
}
