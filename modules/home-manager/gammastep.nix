# modules/home-manager/gammastep.nix
#
# Gammastep — automatic color temperature adjustment (Wayland-native).
# Uses manual coordinates from variables.nix; geoclue2 is unreliable since
# Mozilla Location Service shutdown (2024).
{ variables, ... }: {
  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = variables.latitude;
    longitude = variables.longitude;
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
