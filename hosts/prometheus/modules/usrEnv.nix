{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    useHomeManager = true;

    programs = {
      media.mpv.enable = true;

      launchers = {
        anyrun.enable = true;
        rofi.enable = true;
      };

      screenlock.swaylock.enable = true;
    };
  };
}
