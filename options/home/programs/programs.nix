{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.home.programs = {
    # anyrun options is being used in exclusive/home-manager/programs/anyrun.nix
    anyrun.enable = mkEnableOption {
      default = false;
      description = "Enable AnyRun";
    };

    clipboard.enable = mkEnableOption {
      default = false;
      description = "Enable clipboard service";
    };

    discord.enable = mkEnableOption {
      default = false;
      description = "Enable Discord";
    };

    webcord.enable = mkEnableOption {
      default = false;
      description = "Enable Webcord";
    };

    element.enable = mkEnableOption {
      default = false;
      description = "Enable Element";
    };

    hyprpaper.enable = mkEnableOption {
      default = false;
      description = "Enable Hyprpaper";
    };

    libreoffice.enable = mkEnableOption {
      default = false;
      description = "Enable LibreOffice";
    };

    spotify.enable = mkEnableOption {
      default = false;
      description = "Enable Spotify";
    };

    wlogout.enable = mkEnableOption {
      default = false;
      description = "Enable Wlogout";
    };
  };
}
