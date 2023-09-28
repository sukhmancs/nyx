{
  pkgs,
  inputs,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      xfce.tumbler
      libgsf # odf files
      ffmpegthumbnailer
      ark # GUI archiver for thunar archive plugin
    ];
  };

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  programs = {
    # the thunar file manager
    # we enable thunar here and add plugins instead of in systemPackages
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    # registry for linux, thanks to gnome
    dconf.enable = true;

    # network inspection utility
    wireshark.enable = true;

    # gnome's keyring manager
    seahorse.enable = true;

    # networkmanager tray uility
    nm-applet.enable = true;
  };
}
