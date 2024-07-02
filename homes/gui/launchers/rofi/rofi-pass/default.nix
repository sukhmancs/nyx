{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules meta;

  env = modules.usrEnv;
  rofiPassPackage = with pkgs;
    if meta.isWayland
    then rofi-pass-wayland
    else rofi-pass;
in {
  config = mkIf env.programs.launchers.rofi.enable {
    programs = {
      rofi = {
        pass = {
          enable = true;
          package = rofiPassPackage;
        };
      };
    };

    home.file.".config/rofi-pass" = {
      source = ./rofi-pass-config;
      recursive = true;
    };
  };
}
