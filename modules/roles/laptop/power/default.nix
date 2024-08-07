{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkDefault;
in {
  imports = [./monitor.nix];

  config = {
    hardware.acpilight.enable = true;

    environment.systemPackages = with pkgs; [
      acpi
      powertop
    ];

    services = {
      # handle ACPI events
      acpid.enable = true;

      # allows changing system behavior based upon user-selected power profiles
      power-profiles-daemon.enable = true;

      # temperature target on battery
      undervolt = {
        tempBat = 65; # deg C
        package = pkgs.undervolt;
      };

      # superior power management
      auto-cpufreq = {
        enable = false;
        settings = let
          MHz = x: x * 1000;
        in {
          battery = {
            governor = "powersave";
            scaling_min_freq = mkDefault (MHz 1200);
            scaling_max_freq = mkDefault (MHz 1800);
            turbo = "never";
          };

          charger = {
            governor = "performance";
            scaling_min_freq = mkDefault (MHz 1800);
            scaling_max_freq = mkDefault (MHz 3800);
            turbo = "auto";
          };
        };
      };

      # DBus service that provides power management support to applications.
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };
    };

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };

    # Battery threshold
    systemd.services.batterThreshold = {
      script = ''
        echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
      '';
      wantedBy = ["multi-user.target"];
      description = "Set the charge threshold to protect battery life";
      serviceConfig = {
        Restart = "on-failure";
      };
    };
  };
}
