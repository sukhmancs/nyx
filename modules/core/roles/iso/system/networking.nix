{
  keys,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
in {
  networking.networkmanager = {
    enable = true;
    plugins = mkForce [];
  };

  networking.wireless.enable = mkForce false;

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = mkForce ["multi-user.target"];
  users.users.root.openssh.authorizedKeys.keys = [keys.notashelf];
}
