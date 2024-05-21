{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system;
  env = config.modules.usrEnv;
  cfg = config.meta;
in {
  config = mkIf (sys.video.enable && !cfg.isWayland) {
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString (env.desktop == "i3") "i3"}
      ${lib.optionalString (env.desktop == "awesome") "awesome"}
      zsh
    '';
  };
}
