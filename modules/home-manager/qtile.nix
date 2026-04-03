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
    rofi          # app launcher (mod+d)
    dunst         # notifications
    networkmanagerapplet  # nm-applet for systray
  ];
}
