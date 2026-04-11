# modules/nixos/packages.nix
{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    ripgrep
    fd
    killall
    gnumake
  ];
}
