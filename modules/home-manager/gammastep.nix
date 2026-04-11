# modules/home-manager/gammastep.nix
#
# Gammastep — automatic color temperature adjustment (Wayland-native).
# Location is determined automatically via GeoClue2.
{ ... }:
{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 3500;
    };
    settings.general = {
      fade = 1;
      adjustment-method = "wayland";
    };
  };
}
