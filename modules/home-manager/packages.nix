# modules/home-manager/packages.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Editors & IDEs
    # claude-desktop  # Claude desktop — verify package name: nix search nixpkgs claude-desktop
    zed-editor

    # Development
    python3
    uv
    docker-compose
    lazydocker
    devenv

    # CLI essentials
    fzf
    bat
    eza
    lazygit
    jq
    tldr
    ripgrep
    fd
    tree
    nh
    go-task
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

    # Clipboard manager
    copyq

    # Media
    kdePackages.gwenview # image viewer (KDE)
    vlc # video/audio player
    shared-mime-info # MIME type database

    # Notifications
    libnotify # notify-send
  ];
}
