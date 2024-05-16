{
  config.modules.system = {
    mainUser = "notashelf";
    fs = ["ext4" "vfat" "ntfs"];
    autoLogin = true;

    boot = {
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
      tailscale = {
        enable = false;
        isClient = false;
      };
    };

    virtualization = {
      enable = false;
      docker.enable = false;
      qemu.enable = true;
      podman.enable = false;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      firefox.enable = true;
      chromium.enable = true;
      libreoffice.enable = true;
      element.enable = true;
      spotify.enable = true;
      thunderbird.enable = true;
      # vscode.enable = true;
      webcord.enable = true;

      git.signingKey = "97262307A37BC732";

      gaming = {
        enable = false;
      };

      default = {
        terminal = "foot";
      };
    };
  };
}
