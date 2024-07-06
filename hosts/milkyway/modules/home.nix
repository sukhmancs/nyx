{
  home-manager.users.xi = {
    wayland.windowManager.hyprland.enable = true;
    services.dunst.enable = true;
    programs = {
      rofi.enable = true;
      firefox.enable = true;
      vscode.enable = true;
      swaylock.enable = true;
    };
    gtk.enable = true;
  };
}
