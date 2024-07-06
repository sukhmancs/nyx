{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  env = osConfig.modules.usrEnv;
in {
  imports = [./config.nix];
  config = mkIf config.wayland.windowManager.sway.enable {
    wayland.windowManager.sway = {
      package = pkgs.swayfx;
    };
  };
}
