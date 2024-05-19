# commit=60 means that the system will wait 60 seconds before writing data to the disk,
# this is to reduce the number of writes to the disk and increase the life of the disk.
# but it also means that if the system crashes, you will lose the last 60 seconds of data.
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b2db528f-c0a1-4c2d-a7d2-46190860bba6";
      fsType = "ext4";
      options = ["noatime"];
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
