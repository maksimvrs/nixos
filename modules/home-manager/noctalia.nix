# modules/home-manager/noctalia.nix
#
# Noctalia desktop shell — bar, notifications, widgets.
# Enabled via the noctalia flake homeModule (added to sharedModules in flake.nix).
{ lib, ... }: {
  programs.noctalia-shell = {
    enable = true;

    settings.wallpaper = {
      enabled = true;
      directory = "~/Pictures/Wallpapers";
      fillMode = "crop";
    };

    # Colors come from Stylix via targets.noctalia-shell.
    settings.colorSchemes = {
      useWallpaperColors = false;
      darkMode = true;
      syncGsettings = true;
    };

    # Stylix owns app theming; Noctalia only colors its own bar.
    settings.templates = {
      enableUserTheming = false;
      activeTemplates = [ ];
    };

    # mkForce on visual styles so our config wins over Stylix's noctalia-shell target.
    settings.bar = (lib.mapAttrs (_: lib.mkForce) {
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
    }) // {
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
