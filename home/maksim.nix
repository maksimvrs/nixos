# home/maksim.nix
{ variables, ... }: {
  imports = [
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/terminal.nix
    ../modules/home-manager/editor.nix
    ../modules/home-manager/browser.nix
    ../modules/home-manager/tools.nix
  ];

  home = {
    username      = variables.username;
    homeDirectory = "/home/${variables.username}";
    stateVersion  = variables.stateVersion;
  };

  programs.home-manager.enable = true;
}
