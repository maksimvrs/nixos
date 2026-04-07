# modules/nixos/desktop.nix
{ pkgs, ... }: {
  # Make .desktop files and MIME types from all packages visible to all apps
  environment.pathsToLink = [
    "/share/applications"
    "/share/mime"
  ];

  services.desktopManager.plasma6.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Qtile (Wayland session, selectable from SDDM)
  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = p: with p; [ qtile-extras ];
  };

  # Disable X11 — we only use Wayland
  services.xserver.enable = false;

  # XWayland — needed for X11-only apps (some tray icons)
  programs.xwayland.enable = true;

  # XDG portals — required for flameshot screen capture on Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # portal-wlr only activates for "sway" — must masquerade
  environment.sessionVariables.XDG_CURRENT_DESKTOP = "sway";

  # Touchpad & mouse
  services.libinput = {
    mouse.naturalScrolling = true;
    touchpad.naturalScrolling = true;
    touchpad.tapping = true;
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

  # GeoClue2 — location provider for gammastep etc.
  services.geoclue2.enable = true;

  # GNOME Keyring — secret agent for NetworkManager passwords & SSH keys.
  # PAM integration unlocks the keyring at login; SSH component caches
  # key passphrases so they are entered only once per session.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  programs.ssh.startAgent = false; # SSH agent provided by GNOME Keyring

  # Fingerprint authentication (ThinkPad X1 Carbon Gen 11)
  services.fprintd.enable = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sddm.fprintAuth = true;
  security.pam.services.gtklock.fprintAuth = true;

  # gtklock — Wayland screen locker
  security.pam.services.gtklock = {};
  environment.systemPackages = [ pkgs.gtklock ];

  # Power profiles (performance / balanced / power-saver)
  services.power-profiles-daemon.enable = true;

  # Bluetooth — BlueDevil (KDE's native manager) is enabled by plasma6
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
  };
}
