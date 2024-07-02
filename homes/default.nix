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
  home-manager = mkIf env.useHomeManager {
    # tell home-manager to be as verbose as possible
    verbose = true;

    # use the system configuration’s pkgs argument
    # this ensures parity between nixos' pkgs and hm's pkgs
    useGlobalPkgs = true;

    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;

    # move existing files to the .hm.old suffix rather than failing
    # with a very long error message about it
    backupFileExtension = "hm.old";

    # extra specialArgs passed to Home Manager
    # for reference, the config argument in nixos can be accessed
    # in home-manager through osConfig without us passing it
    extraSpecialArgs = specialArgs;

    # per-user Home Manager configuration
    # the genAttrs function generates an attribute set of users
    # as `user = ./user` where user is picked from a list of
    # users in modules.system.users
    # the system expects user directories to be found in the present
    # directory, or will exit with directory not found errors
    # users = genAttrs config.modules.system.users (name: ./${name});
    users.notashelf = {
      imports = [
        ./gui
        ./media
        ./misc
        ./services
        ./tui
        ./themes
      ];

      home = {
        username = "notashelf";
        homeDirectory = "/home/notashelf";
        extraOutputsToInstall = ["doc" "devdoc"];

        # This is, and should remain, the version on which you have initiated
        # the home-manager configuration. Similar to the `stateVersion` in the
        # NixOS module system, you should not be changing it.
        # I will personally strangle every moron who just puts nothing but "DONT CHANGE" next
        # to this value
        stateVersion = "23.05";
      };

      manual = {
        # Try to save some space by not installing variants of the home-manager
        # manual, which I don't use at all. Unlike what the name implies, this
        # section is for home-manager related manpages only, and does not affect
        # whether or not manpages of actual packages will be installed.
        manpages.enable = false;
        html.enable = false;
        json.enable = false;
      };

      # let HM manage itself when in standalone mode
      programs.home-manager.enable = true;

      # reload system units when changing configs
      systemd.user.startServices = "sd-switch"; # or "legacy" if "sd-switch" breaks again
    };
  };
}
