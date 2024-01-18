# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
    fsType = "btrfs";
    options = ["subvol=root"];
  };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/82144284-cf1d-4d65-9999-2e7cdc3c75d4";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
    fsType = "btrfs";
    options = ["subvol=nix"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
    fsType = "btrfs";
    options = ["subvol=persist"];
    neededForBoot = true;
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/b79d3c8b-d511-4d66-a5e0-641a75440ada";
    fsType = "btrfs";
    options = ["subvol=log"];
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FDED-3BCF";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/0d1fc824-623b-4bb8-bf7b-63a3e657889d";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networkingnetworking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}