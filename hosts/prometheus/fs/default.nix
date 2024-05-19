{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b2db528f-c0a1-4c2d-a7d2-46190860bba6";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/045F-11EB";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/20796d35-e8af-454d-bede-5634823202ec";}
  ];
}
