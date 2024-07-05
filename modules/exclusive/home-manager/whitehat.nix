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
      binwalk
      binutils
      diffoscopeMinimal
      nmap
      nmapsi4
    ];
  };
}
