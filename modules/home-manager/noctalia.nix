# modules/home-manager/noctalia.nix
#
# Noctalia desktop shell — bar, notifications, widgets.
# Enabled via the noctalia flake homeModule (added to sharedModules in flake.nix).
_: {
  programs.noctalia-shell = {
    enable = true;

    # Pin to the current schema version so Noctalia skips legacy migrations.
    # Without this, Migration45 overrides bar.barType back to "simple" because
    # it only honours the old boolean `bar.floating` key.
    settings.settingsVersion = 59;

    settings.wallpaper = {
      enabled = true;
      directory = "~/Pictures/Wallpapers";
      fillMode = "crop";
    };

    settings.colorSchemes = {
      useWallpaperColors = false;
      darkMode = true;
      syncGsettings = true;
    };

    settings.bar = {
      barType = "floating";
      position = "top";
      density = "comfortable";
      marginVertical = 8;
      marginHorizontal = 10;
      backgroundOpacity = 0.85;
      useSeparateOpacity = true;
      showOutline = false;
      showCapsule = true;
      capsuleOpacity = 0.6;
      widgetSpacing = 8;
      contentPadding = 4;
      displayMode = "always_visible";

      widgets = {
        left = [
          { id = "Launcher"; }
          { id = "Clock"; formatHorizontal = "HH:mm:ss ddd, MMM dd"; }
          {
            id = "SystemMonitor";
            compactMode = true;
            showCpuUsage = true;
            showCpuTemp = true;
            showMemoryUsage = true;
            useMonospaceFont = true;
          }
          { id = "ActiveWindow"; }
          { id = "MediaMini"; }
        ];
        center = [
          { id = "Workspace"; }
        ];
        right = [
          { id = "Tray"; }
          { id = "plugin:privacy-indicator"; }
          { id = "plugin:network-manager-vpn"; }
          { id = "Network"; displayMode = "alwaysShow"; }
          { id = "NotificationHistory"; }
          { id = "KeyboardLayout"; displayMode = "forceOpen"; }
          {
            id = "Battery";
            displayMode = "graphic";
            showPowerProfiles = true;
            showNoctaliaPerformance = true;
          }
          { id = "Volume"; displayMode = "alwaysShow"; }
          { id = "Brightness"; displayMode = "alwaysShow"; }
          { id = "ControlCenter"; }
        ];
      };
    };

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        network-manager-vpn = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };
  };
}
