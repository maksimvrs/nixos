# home/maksim.nix
{ variables, ... }: {
  imports = [
    ../modules/home-manager/packages.nix
    ../modules/home-manager/neovim.nix
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/ssh.nix
    ../modules/home-manager/kitty.nix
    ../modules/home-manager/cursor.nix
    ../modules/home-manager/zen-browser.nix
    ../modules/home-manager/claude.nix
    ../modules/home-manager/dunst.nix
    ../modules/home-manager/gammastep.nix
    ../modules/home-manager/wofi.nix
    ../modules/home-manager/qtile.nix
    ../modules/home-manager/xdg.nix
    ../modules/home-manager/opencode.nix
    ../modules/home-manager/obs.nix
  ];

  home = {
    username      = variables.username;
    homeDirectory = "/home/${variables.username}";
    stateVersion  = variables.stateVersion;
  };

  programs.home-manager.enable = true;

  systemd.user.tmpfiles.rules = [
    "d %h/projects  0755 - - -"
    "d %h/zeustrack 0755 - - -"
  ];
}
