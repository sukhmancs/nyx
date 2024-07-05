{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.system.programs;
  dev = modules.device;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = {
    home.packages = with pkgs; [
      # CLI
      libnotify
      imagemagick
      bitwarden-cli
      trash-cli
      slides
      brightnessctl
      pamixer
      nix-tree
      tgpt
    ];
  };
}
