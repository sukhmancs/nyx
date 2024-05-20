{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.vesktop.enable {
    home.packages = [pkgs.vesktop];
    xdg.configFile = {
      "VencordDesktop/VencordDesktop/settings/settings.json".text = builtins.toJSON {
        notifyAboutUpdates = true;
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-pink.theme.css"
        ];
        enabledThemes = [
        ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          BadgeAPI.enabled = true;
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          ContextMenuAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          NoticesAPI.enabled = true;
          ServerListAPI.enabled = true;
          NoTrack.enabled = true;
          Settings = {
            enabled = true;
            settingsLocation = "aboveActivity";
          };
          SupportHelper.enabled = true;
          AlwaysAnimate.enabled = true;
          AlwaysTrust.enabled = true; # remove "do you trust this link" dialogs.
          AnonymiseFileNames.enabled = true;
          BetterGifPicker.enabled = true;
          BetterSettings.enabled = true;
          BetterUploadButton.enabled = true;
          BlurNSFW.enabled = true;
          ClearURLs.enabled = true;
          CopyUserURLs.enabled = true;
          CrashHandler.enabled = true;
          EmoteCloner.enabled = true;
          Experiments.enabled = true;
          FavoriteEmojiFirst.enabled = true;
          LoadingQuotes.enabled = true;
          MemberCount.enabled = false;
          NSFWGateBypass.enabled = true;
          PermissionFreeWill.enabled = true;
          PreviewMessage.enabled = true;
          ReadAllNotificationsButton.enabled = true;
          RelationshipNotifier.enabled = true;
          ReverseImageSearch.enabled = true;
          ShowConnections.enabled = true;
          ShowHiddenChannels.enabled = true;
          SpotifyControls.enabled = true;
          UrbanDictionary.enabled = true;
          ValidUser.enabled = true;
          MessageClickActions.enabled = true;
          InvisibleChat.enabled = true;
          SilentTyping.enabled = true;
          WebContextMenus = {
            enabled = true;
            addBack = true;
          };
          WebKeybinds = {
            enabled = true;
          };
          WhoReacted = {
            enabled = true;
          };
        };

        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };

        # TODO: Investigate this.
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1713336128416;
        };
      };
    };
  };
}
