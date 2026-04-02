# modules/home-manager/terminal.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    kitty
  ];
}
