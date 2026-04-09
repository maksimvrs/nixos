# modules/home-manager/packages.nix
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Editors & IDEs
    # claude-desktop  # Claude desktop — verify package name: nix search nixpkgs claude-desktop

    # Development
    python3
    uv
    docker-compose
    lazydocker
    devenv

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
    nh
    fastfetch
    httpie

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
    glab
    beekeeper-studio
    mongodb-compass

    # File manager
    nautilus

    # Media
    kdePackages.gwenview  # image viewer (KDE)
    shared-mime-info   # MIME type database

    # Notification sounds
    sound-theme-freedesktop
    pulseaudio  # paplay for dunst notification sounds
  ];
}
