{
  self,
  config,
  lib,
  ...
}: let
  inherit (lib) optionals mkIf mkForce;

  dev = config.modules.device;
in {
  config = {
    hardware = {
      nvidia = mkIf (builtins.elem dev.gpu ["nvidia" "hybrid-nv"]) {
        open = mkForce false;

        prime = {
          offload.enable = true;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };
    };

    boot.kernelParams = [
      "i8042.nomux" # Don't check presence of an active multiplexing controller
      "i8042.nopnp" # Don't use ACPIPn<P / PnPBIOS to discover KBD/AUX controllers
    ];

    system = {
      stateVersion = "23.05";
      configurationRevision = self.rev or "dirty";
    };
  };
}
