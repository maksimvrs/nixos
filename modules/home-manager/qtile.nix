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
