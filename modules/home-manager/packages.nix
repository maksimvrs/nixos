# modules/home-manager/packages.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Editors & IDEs
    # claude-desktop  # Claude desktop — verify package name: nix search nixpkgs claude-desktop

    # Development
    python3
    uv
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

    # File manager
    nautilus

    # Media
    kdePackages.gwenview  # image viewer (KDE)
    shared-mime-info   # MIME type database
  ];
}
