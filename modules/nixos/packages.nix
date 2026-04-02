# modules/nixos/packages.nix
{ pkgs, ... }: {
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
