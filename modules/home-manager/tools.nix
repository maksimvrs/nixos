# modules/home-manager/tools.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI essentials
    btop
    fzf
    bat
    eza
    lazygit
    jq
    tldr
    ripgrep
    fd

    # Archives
    zip
    unzip

    # Misc
    wget
    curl
  ];
}
