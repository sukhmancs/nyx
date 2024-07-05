{
  inputs',
  self',
  self,
  config,
  lib,
  ...
}: let
  inherit (self) inputs;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) genAttrs;
  inherit (config) modules;

  env = modules.usrEnv;
  sys = modules.system;
  defaults = sys.programs.default;

  specialArgs = {inherit inputs self inputs' self' defaults;};
in {
  home-manager = {
    # Enable verbose logging for Home Manager
    verbose = true;

    # Synchronize package sets between NixOS and Home Manager
    useGlobalPkgs = true;

    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;

    # Define a standard file extension for backup files created by Home Manager
    backupFileExtension = "hm.backup";

    # Additional special arguments for Home Manager, enhancing configurability
    extraSpecialArgs = specialArgs;

    # per-user Home Manager configuration
    users.xi = {
      imports = [
        ./gui # Graphical user interface settings
        ./media # Media-related configurations
        ./services # Service configurations
        ./tui # Terminal user interface applications
        ./themes # Theme and appearance settings
      ];

      home = {
        username = "xi";
        homeDirectory = "/home/xi";
        # Specify additional outputs to install, such as documentation
        extraOutputsToInstall = ["doc" "devdoc"];

        # The initial version of Home Manager configuration, should not be changed after set
        stateVersion = "23.05";
      };

      # Configuration for the Home Manager manual and documentation
      manual = {
        # Disable installation of various manual formats to save space
        manpages.enable = false;
        html.enable = false;
        json.enable = false;
      };

      # Enable Home Manager to manage its own configurations
      programs.home-manager.enable = true;

      # Configure systemd to reload user services upon configuration changes
      systemd.user.startServices = "sd-switch"; # or "legacy" if "sd-switch" breaks again
    };
  };
}
