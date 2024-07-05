{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.modules) device;

  waybar_config = import ./presets/config.nix {inherit osConfig config lib pkgs;};
  waybar_style = import ./presets/style.nix;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf (builtins.elem device.type acceptedTypes) {
    home.packages = with pkgs.python3Packages; [requests];
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar;
      settings = waybar_config;
      style = waybar_style;
    };
  };
}
