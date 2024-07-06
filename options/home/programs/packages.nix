{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.home.exclusive = {
    packages = mkEnableOption {
      default = false;
      description = "Enable extra home-manager packages such as whitehat tools, media tools, and recording tools";
    };
  };
}
