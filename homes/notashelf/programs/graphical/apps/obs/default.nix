{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules meta;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins;
        [
          obs-gstreamer
          obs-pipewire-audio-capture
          obs-vkcapture
        ]
        ++ optional meta.isWayland
        pkgs.obs-studio-plugins.wlrobs;
    };
  };
}
