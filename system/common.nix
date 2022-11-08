{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  configure-gtk = let
    schema = pkgs.gsettings-desktop-schemas;
    datadir = "${schema}/share/gesettings/schemas/${schema.name}";
  in
    pkgs.writeShellScriptBin "configure-gtk" ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gesettings set $gnome_schema gtk-theme 'Adwaita'
    '';
in {
  # disabledModules = [ "services/hardware/udev.nix" ];
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./network.nix
    ./security.nix
    ./blocker.nix
    ./services.nix
  ];

  environment.variables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 4d";
    };

    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    nixPath = [
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];

    settings = {
      experimental-features = "nix-command flakes";
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      allowed-users = ["notashelf"];
      # use binary cache, its not gentoo
      substituters = [
        "https://cache.nixos.org"
        "https://fortuneteller2k.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  documentation.enable = false; # its trash anyways

  services.dbus = {
    enable = true;
    packages = [pkgs.dconf];
  };
  services.udev.packages = [pkgs.gnome.gnome-settings-daemon];

  environment.systemPackages = with pkgs; [
    gnome.adwaita-icon-theme
    configure-gtk
    git
    glib
    greetd.gtkgreet
    #cryptsetup
  ];

  environment.defaultPackages = []; # this removes bloat (not really)
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # saves space
    supportedLocales = ["en_US.UTF-8/UTF-8"];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "trq";
  };

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  programs = {
    ccache.enable = true;
    less.enable = true;
    hyprland = {
      enable = true;
    };
  };

  environment = {
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
      "greetd/environments".text = ''
        Hyprland
        sway
        zsh
      '';
    };
  };

  # Set timezone
  time.timeZone = "Europe/Istanbul";

  users.users.notashelf = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "input"
      "lp"
      "networkmanager"
      "systemd-journal"
      "video"
      "wheel"
    ];
    uid = 1001;
    shell = pkgs.zsh;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  programs.light.enable = true;

  system.stateVersion = "22.05"; # DONT TOUCH THIS
}