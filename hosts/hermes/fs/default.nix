{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b2db528f-c0a1-4c2d-a7d2-46190860bba6";
      fsType = "ext4";
      # options = ["subvol=root" "compress=zstd"];
    };

    # "/nix" = {
    #   device = "/dev/disk/by-uuid/b26ec8d8-8203-4252-8c32-0e0de3d90477";
    #   fsType = "btrfs";
    #   options = ["subvol=nix" "compress=zstd" "noatime"];
    # };

    # "/home" = {
    #   device = "/dev/disk/by-uuid/b26ec8d8-8203-4252-8c32-0e0de3d90477";
    #   fsType = "btrfs";
    #   options = ["subvol=home" "compress=zstd"];
    # };

    "/boot" = {
      device = "/dev/disk/by-uuid/045F-11EB";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/20796d35-e8af-454d-bede-5634823202ec";}
  ];
}
