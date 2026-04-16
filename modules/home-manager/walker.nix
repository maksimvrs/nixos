# modules/home-manager/walker.nix
#
# Walker + Elephant — Wayland-native application runner.
{ pkgs, ... }:
{
  home.packages = [ pkgs.elephant ];

  services.walker = {
    enable = true;
    systemd.enable = true;

    settings = {
      close_when_open = true;
      force_keyboard_focus = true;
    };
  };

  systemd.user.services.walker.Service.Environment = "PATH=${pkgs.elephant}/bin";
  systemd.user.services.walker.Unit.After = [ "elephant.service" ];

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

  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant - Data provider for Walker";
      Before = [ "walker.service" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.elephant}/bin/elephant";
      Restart = "on-failure";
      Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/maksim/bin";
    };
  };
}
