# modules/home-manager/noctalia.nix
#
# Noctalia desktop shell — bar, notifications, widgets.
# Enabled via the noctalia flake homeModule (added to sharedModules in flake.nix).
_: {
  programs.noctalia-shell = {
    enable = true;

    settings.wallpaper = {
      enabled = true;
      directory = "~/Pictures/Wallpapers";
      fillMode = "crop";
    };

    settings.bar.widgets = {
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
        { id = "Battery"; displayMode = "graphic"; }
        { id = "Volume"; displayMode = "alwaysShow"; }
        { id = "Brightness"; displayMode = "alwaysShow"; }
        { id = "ControlCenter"; }
      ];
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
