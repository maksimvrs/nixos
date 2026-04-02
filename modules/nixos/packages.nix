# modules/nixos/packages.nix
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    ripgrep
    fd
    killall
    gnumake
  ];
}
