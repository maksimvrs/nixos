# modules/nixos/desktop.nix
{ pkgs, ... }:
{
  # Make .desktop files and MIME types from all packages visible to all apps
  environment = {
    pathsToLink = [
      "/share/applications"
      "/share/mime"
    ];
    sessionVariables = {
      # portal-wlr only activates for "sway" — must masquerade
      XDG_CURRENT_DESKTOP = "sway";
      # Force Qt apps (KDE/kded6/dolphin/okular/ark/gwenview) to use the
      # Wayland platform plugin. Without this, DBus-activated Qt processes
      # (notably kded6) don't see WAYLAND_DISPLAY, try xcb, fail to connect
      # to a display and crash — which breaks file opening in Dolphin/KIO
      # and, transitively, in Nautilus since its default handlers are Qt apps.
      QT_QPA_PLATFORM = "wayland;xcb";
      # Noctalia lockscreen reads PAM config from /etc/pam.d/noctalia
      # (see security.pam.services.noctalia below) instead of the default /etc/pam.d/login.
      NOCTALIA_PAM_SERVICE = "noctalia";
    };
  };

  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    # Touchpad & mouse
    libinput = {
      mouse.naturalScrolling = true;
      touchpad.naturalScrolling = true;
      touchpad.tapping = true;
    };

    # PipeWire audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true; # explicit — default but stated for clarity
    };
    pulseaudio.enable = false;

    # GeoClue2 — location provider for gammastep etc.
    geoclue2.enable = true;

    # GNOME Keyring — secret agent for NetworkManager passwords & SSH keys.
    # PAM integration unlocks the keyring at login; SSH component caches
    # key passphrases so they are entered only once per session.
    gnome.gnome-keyring.enable = true;

    # Fingerprint authentication (ThinkPad X1 Carbon Gen 11)
    fprintd.enable = true;

    # Power profiles (performance / balanced / power-saver)
    power-profiles-daemon.enable = true;
  };

  # XWayland — needed for X11-only apps (some tray icons)
  programs = {
    xwayland.enable = true;
    ssh.startAgent = false; # SSH agent provided by GNOME Keyring
    niri.enable = true;
  };

  # XDG portals — required for flameshot screen capture on Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    rtkit.enable = true;
    pam.services = {
      # No fprintAuth here: fingerprint login bypasses pam_unix → pam_gnome_keyring
      # never gets the password → keyring stays locked and NetworkManager/browsers
      # lose their saved secrets. Typing the password once at SDDM unlocks everything.
      sddm.enableGnomeKeyring = true;
      sudo.fprintAuth = true;
      login.fprintAuth = true;
      noctalia.fprintAuth = true;
    };
  };

  # Bluetooth — BlueDevil (KDE's native manager) is enabled by plasma6
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
