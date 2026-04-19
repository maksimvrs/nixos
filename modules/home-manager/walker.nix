# modules/home-manager/walker.nix
#
# Walker + Elephant — Wayland-native application runner.
{ pkgs, ... }:
{
  home.packages = [ pkgs.elephant ];

  services.walker = {
    enable = true;
    systemd.enable = false;

    settings = {
      close_when_open = true;
      force_keyboard_focus = true;
    };
  };

  xdg.configFile."elephant/desktopapplications.toml".text = ''
    history_when_empty = true
  '';

  xdg.configFile."elephant/menus/power.toml".text = ''
    name = "power"
    name_pretty = "Power"
    icon = "system-shutdown"
    fixed_order = true

    [[entries]]
    text = "Shutdown"
    icon = "system-shutdown"
    actions = { "use" = "systemctl poweroff" }

    [[entries]]
    text = "Reboot"
    icon = "system-reboot"
    actions = { "use" = "systemctl reboot" }

    [[entries]]
    text = "Lock"
    icon = "system-lock-screen"
    actions = { "use" = "gtklock" }

    [[entries]]
    text = "Logout"
    icon = "system-log-out"
    actions = { "use" = "loginctl terminate-user $USER" }
  '';

}
