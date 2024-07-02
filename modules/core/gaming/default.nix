{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  imports = [
    ./gamescope.nix
    ./gamemode.nix
    ./steam.nix
    ./sunshine.nix
  ];

  config.modules.system.programs = mkIf config.modules.profiles.gaming.enable {
    steam.enable = true;
    gaming.enable = true;
  };
}
