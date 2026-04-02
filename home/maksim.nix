# home/maksim.nix
{ variables, ... }: {
  imports = [
    ../modules/home-manager/packages.nix
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/kitty.nix
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
