{
  config,
  pkgs,
  ...
}: {
  # modules.system = {
  #   mainUser = "xi";
  #   fs.enabledFilesystems = ["btrfs" "ext4" "vfat"];
  #   impermanence.root.enable = true;

  #   boot = {
  #     secureBoot = false;
  #     kernel = pkgs.linuxPackages_xanmod_latest;
  #     plymouth.enable = true;
  #     loader = "systemd-boot";
  #     enableKernelTweaks = true;
  #     initrd.enableTweaks = true;
  #     loadRecommendedModules = true;
  #     tmpOnTmpfs = true;
  #   };

  #   encryption = {
  #     enable = true;
  #     device = "enc";
  #   };

  #   yubikeySupport.enable = false; # when this is true openssh-agent will turn off.
  #   autoLogin = true;

  #   video.enable = true;
  #   sound.enable = true;
  #   bluetooth.enable = true;
  #   printing.enable = true;
  #   emulation.enable = true;

  #   networking = {
  #     optimizeTcp = true;
  #     nftables.enable = false; # Change me
  #     #      tailscale = { # FIXME:
  #     #        enable = true;
  #     #        isClient = true;
  #     #      };
  #   };

  #   security = {
  #     fixWebcam = false;
  #     lockModules = true;
  #     usbguard.enable = true;
  #   };

  #   virtualization = {
  #     enable = true;
  #     docker.enable = false;
  #     qemu.enable = true;
  #     podman.enable = false;
  #   };

  #   programs = {
  #     cli.enable = true;
  #     gui.enable = true;

  #     vscode.enable = true;
  #     spotify.enable = true;

  #     git.signingKey = "EB28A227A8C9E8F0";

  #     gaming = {
  #       enable = false;
  #     };

  #     default = {
  #       terminal = "foot";
  #     };
  #   };
  # };

  config = {
    boot.loader.grub.enable = true;
    boot.plymouth.enable = true;
    services.seatd.enable = true;
    xdg.portal.enable = true;

    modules.system = {
      mainUser = "xi";
      impermanence.root.enable = true;

      encryption = {
        enable = true;
        device = "enc";
      };
    };
  };
}
