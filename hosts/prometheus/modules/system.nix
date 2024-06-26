{pkgs, ...}: {
  modules.system = {
    mainUser = "notashelf";
    fs.enabledFilesystems = ["btrfs" "vfat" "ntfs"];
    autoLogin = true;

    boot = {
      secureBoot = false;
      kernel = pkgs.linuxPackages_xanmod_latest;
      plymouth.enable = true;
      loader = "systemd-boot";
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = true;
    };

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = false;
    printing.enable = false;

    networking = {
      optimizeTcp = true;
      nftables.enable = true;
      tailscale = {
        enable = true;
        isClient = true;
        isServer = false;
      };
    };

    security = {
      fixWebcam = false;
      lockModules = true;
      usbguard.enable = true;
    };

    virtualization = {
      enable = true;
      docker.enable = false;
      qemu.enable = true;
      podman.enable = false;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      chromium.enable = true;
      spotify.enable = true;
      vscode.enable = true;
      discord.enable = true;

      git.signingKey = "97262307A37BC732";

      nushell.enable = false;

      gaming = {
        enable = false;
      };

      default = {
        terminal = "foot";
      };
    };
  };
}
