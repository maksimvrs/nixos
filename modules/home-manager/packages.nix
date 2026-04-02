# modules/home-manager/packages.nix
{ pkgs, zenBrowserPackages, ... }: {
  home.packages = with pkgs; [
    # Browser
    zenBrowserPackages.default

    # Editors & IDEs
    neovim
    code-cursor-fhs  # Cursor AI editor (FHS wrapper for extension support)
    # claude-desktop  # Claude desktop — verify package name: nix search nixpkgs claude-desktop

    # Development
    python3
    docker-compose

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

    # Communication
    telegram-desktop
    slack

    # Productivity
    bitwarden-desktop
    sublime-merge
  ];
}
