{ inputs, pkgs, config, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    wf-recorder
    inputs.webcord.packages.${pkgs.system}.default
    todo
    calcurse
    gimp
    neofetch
    rofi-wayland
    vlc
    pavucontrol
    bottom
    wofi
    imv
    hyperfine
    swaybg
    slurp
    grim
    transmission-gtk
    fzf
    gum
    pngquant
    wl-clipboard
    proxychains-ng
    exa
    ffmpeg
    unzip
    libnotify
    gnupg
    yt-dlp
    ripgrep
    rsync
    imagemagick
    unrar
    tealdeer
    killall
    du-dust
    bandwhich
    grex
    fd
    xfce.thunar
    xh
    jq
    figlet
    lm_sensors
    keepassxc
    python3
    git
    dconf
    gcc
    rustc
    rustfmt
    cargo
  ];
}
