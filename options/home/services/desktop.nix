{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool enum package;

  cfg = config.modules.home;
  sys = config.modules.system;
in {
  options.modules.home = {
    desktops = {
      hyprland.enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to enable Hyprland window manager.
        '';
      };

      sway.enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to enable Sway window manager.
        '';
      };

      i3.enable = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to enable i3 window manager
        '';
      };
    };
  };
}
