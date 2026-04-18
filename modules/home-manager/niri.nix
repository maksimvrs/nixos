# modules/home-manager/niri.nix
#
# Manages niri dotfiles and user-level dependencies.
# The actual niri config lives in home/dotfiles/niri/ — this module
# symlinks everything from that directory into ~/.config/niri/.
{ pkgs, ... }:
{
  xdg.configFile."niri" = {
    source = ../../home/dotfiles/niri;
    recursive = true;
  };

  home.packages = with pkgs; [
    xwayland-satellite # XWayland support for niri
  ];
}
