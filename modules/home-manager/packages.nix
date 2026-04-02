# modules/home-manager/packages.nix
{ pkgs, zenBrowserPackages, ... }: {
  home.packages = with pkgs; [
    # Browser
    zenBrowserPackages.default

    # Editor
    neovim

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
