{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.home.programs = {
    # anyrun options is being used in exclusive/home-manager/programs/anyrun.nix
    anyrun = mkEnableOption {
      default = false;
      description = "Enable AnyRun";
    };

    clipboard = mkEnableOption {
      default = false;
      description = "Enable clipboard service";
    };

    discord = mkEnableOption {
      default = false;
      description = "Enable Discord";
    };

    webcord = mkEnableOption {
      default = false;
      description = "Enable Webcord";
    };

    element = mkEnableOption {
      default = false;
      description = "Enable Element";
    };

    hyprpaper = mkEnableOption {
      default = false;
      description = "Enable Hyprpaper";
    };

    libreoffice = mkEnableOption {
      default = false;
      description = "Enable LibreOffice";
    };

    spotify = mkEnableOption {
      default = false;
      description = "Enable Spotify";
    };

    wlogout = mkEnableOption {
      default = false;
      description = "Enable Wlogout";
    };
  };
}
