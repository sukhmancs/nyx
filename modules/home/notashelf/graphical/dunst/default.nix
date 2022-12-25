{
  config,
  self,
  pkgs,
  lib,
  ...
}: let
  volume = let
    pamixer = lib.getExe pkgs.pamixer;
    notify-send = pkgs.libnotify + "/bin/notify-send";
  in
    pkgs.writeShellScriptBin "volume" ''
      #!/bin/sh

      ${pamixer} "$@"

      volume="$(${pamixer} --get-volume-human)"

      if [ "$volume" = "muted" ]; then
          ${notify-send} -r 69 \
              -a "Volume" \
              "Muted" \
              -i ${./icons/mute.svg} \
              -t 888 \
              -u low
      else
          ${notify-send} -r 69 \
              -a "Volume" "Currently at $volume" \
              -h int:value:"$volume" \
              -i ${./icons/volume.svg} \
              -t 888 \
              -u low
      fi
    '';
in {
  home.packages = [volume];
  services.dunst = {
    enable = true;
    package = pkgs.dunst.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "k-vernooy";
        repo = "dunst";
        rev = "61567d58855ba872f8237861ddcd786d03dd2631";
        sha256 = "ttaaomjb3CclZG9JPdzDBj5XXlqRaKGPBY3ahFofqVM=";
      };
    });
    iconTheme = {
      package = self.packages.${pkgs.system}.catppuccin-folders;
      name = "Papirus";
    };
    settings = let
      inherit (config.colorscheme) colors;
    in {
      global = {
        frame_color = "#${colors.base0F}";
        separator_color = "#${colors.base0D}";
        width = 220;
        height = 220;
        offset = "0x15";
        font = "Iosevka 16";
        corner_radius = 10;
        origin = "top-center";
        notification_limit = 3;
        idle_threshold = 120;
        ignore_newline = "no";
        mouse_left_click = "close_current";
        mouse_right_click = "close_all";
        sticky_history = "yes";
        history_length = 20;
        show_age_threshold = 60;
        ellipsize = "middle";
        padding = 10;
        always_run_script = true;
        frame_width = 3;
        transparency = 10;
        progress_bar = true;
        progress_bar_frame_width = 0;
        highlight = "#${colors.base06}";
      };
      fullscreen_delay_everything.fullscreen = "delay";
      urgency_low = {
        background = "#${colors.base02}";
        foreground = "#${colors.base05}";
        timeout = 5;
      };
      urgency_normal = {
        background = "##${colors.base02}";
        foreground = "#${colors.base05}";
        timeout = 6;
      };
      urgency_critical = {
        background = "##${colors.base02}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base09}";
        timeout = 0;
      };
    };
  };
}
