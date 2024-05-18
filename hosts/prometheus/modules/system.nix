{
  config.modules.system = {
    mainUser = "notashelf";
    fs = ["ext4" "vfat" "ntfs"];
    autoLogin = true;

    boot = {
      loader = "systemd-boot";
      secureBoot = false;
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = true;
      plymouth = {
        enable = true;
        withThemes = false;
      };
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
      tor.enable = true;
      fixWebcam = false;
      lockModules = true;
      auditd.enable = true;
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
      #vscode.enable = true;
      webcord.enable = true;

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
