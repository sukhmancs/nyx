{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.home.programs = {
    # Signing key is being used in homes/shared/programs/git.nix
    git = {
      signingKey = mkOption {
        type = types.str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };
  };
}
