# modules/nixos/desktop.nix
{ pkgs, ... }: {
  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # PipeWire audio
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    wireplumber.enable = true; # explicit — default but stated for clarity
  };
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  # Bluetooth — blueman provides a system tray applet useful alongside KDE BlueDevil
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # XDG portals (required for Plasma/Wayland apps)
  xdg.portal = {
    enable       = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };
}
