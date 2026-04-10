# modules/home-manager/qtile.nix
#
# Manages qtile dotfiles and user-level dependencies.
# The actual qtile config lives in home/dotfiles/qtile/ — this module
# symlinks everything from that directory into ~/.config/qtile/.
{ pkgs, ... }: {
  xdg.configFile."qtile" = {
    source    = ../../home/dotfiles/qtile;
    recursive = true;
  };

  # Compositor-specific systemd target. qtile's autostart hook starts this
  # target, which in turn activates graphical-session.target (via BindsTo).
  # Without this, user services like gammastep never get triggered, since
  # graphical-session.target refuses manual start.
  systemd.user.targets.qtile-session = {
    Unit = {
      Description = "qtile compositor session";
      BindsTo = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
      After = [ "graphical-session-pre.target" ];
    };
  };

  home.packages = with pkgs; [
    # Utilities used by qtile keybindings / bar
    brightnessctl          # brightness control (XF86 keys)
    copyq                  # clipboard manager (mod+v)
    swaybg                 # wallpaper (Wayland-native)
    grim                   # screenshot capture (Wayland-native)
    slurp                  # region selector for grim
    networkmanagerapplet   # nm-applet for systray
    noto-fonts-color-emoji # emoji in status bar
    wl-clipboard           # Wayland clipboard
  ];
}
