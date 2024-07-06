#
# Override - rofi with wayland plugins
#
{lib, ...}: let
  inherit (lib) mkForce;
in {
  home-manager.users.xi = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland.override {
        plugins = [
          pkgs.rofi-rbw
          pkgs.rofi-calc-wayland
          pkgs.rofi-emoji-wayland
        ];
      };
      font = mkForce "Iosevka Nerd Font 14";
      extraConfig = {
        modi = "drun,filebrowser,calc,emoji";
        drun-display-format = " {name} ";
        sidebar-mode = true;
        matching = "prefix";
        scroll-method = 0;
        disable-history = false;
        show-icons = true;

        display-drun = " Run";
        display-run = " Run";
        display-filebrowser = " Files";
        display-calc = "󰃬 Calculator";
        display-emoji = "💀 Emoji";
      };
    };
  };
}
