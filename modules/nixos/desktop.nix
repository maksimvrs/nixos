# modules/nixos/desktop.nix
{ ... }: {
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

  # Bluetooth — BlueDevil (KDE's native manager) is enabled by plasma6
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
}
