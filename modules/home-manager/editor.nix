# modules/home-manager/editor.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    neovim
  ];
}
