{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  dev = osConfig.modules.device;
  sys = osConfig.modules.system;
  cfg = osConfig.modules.style;

  acceptedTypes = ["laptop" "desktop" "hybrid" "lite"];
in {
  config = mkIf (builtins.elem dev.type acceptedTypes && sys.video.enable) {
    xdg.configFile."kdeglobals".source = cfg.qt.kdeglobals.source;

    qt = {
      enable = true;
      platformTheme = mkIf cfg.forceGtk "gtk"; # just an override for QT_QPA_PLATFORMTHEME, takes "gtk" or "gnome"
      style = {
        name = "${cfg.qt.theme.name}";
        package = cfg.qt.theme.package;
      };
    };

    home.packages = with pkgs; [
      qt5.qttools
      qt6Packages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      breeze-icons

      # add theme package to path just in case
      cfg.qt.theme.package
    ];

    home.sessionVariables = {
      #QT_QPA_PLATFORMTHEME = "kvantum"; # can't be used alongside kvantum, nix above knows why
      #QT_STYLE_OVERRIDE = "kvantum";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      DISABLE_QT5_COMPAT = "0";

      # tell calibre to use the dark theme, because the light one hurts my eyes
      CALIBRE_USE_DARK_PALETTE = "1";
    };

    xdg.configFile."Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.kvconfig";
      sha256 = "1f8xicnc5696g0a7wak749hf85ynfq16jyf4jjg4dad56y4csm6s";
    };

    xdg.configFile."Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Blue/Catppuccin-Mocha-Blue.svg";
      sha256 = "0vys09k1jj8hv4ra4qvnrhwxhn48c2gxbxmagb3dyg7kywh49wvg";
    };

    /*
    xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
      General.Theme = "Catppuccin-Mocha-Mauve";
    };
    */

    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=catppuccin

      [Applications]
      catppuccin=qt5ct, org.kde.dolphin, org.kde.kalendar, org.qbittorrent.qBittorrent, hyprland-share-picker, dolphin-emu, Nextcloud, nextcloud
    '';
  };
}
