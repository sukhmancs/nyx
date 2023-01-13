{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  sys = config.modules.system.fs;
in {
  config = mkMerge [
    (mkIf (sys.fs builtins.elem ["btrfs"]) {
      # scrub btrfs devices
      services.btrfs.autoScrub.enable = true;

      # this fixes initrd.systemd for whatever reason
      boot = {
        initrd = {
          supportedFilesystems = ["btrfs"];
        };
      };
    })

    (mkIf (sys.fs builtins.elem ["ext4"]) {
      # TODO
    })

    (mkIf (sys.fs builtins.elem ["zfs"]) {
      # TODO
    })
  ];
}
