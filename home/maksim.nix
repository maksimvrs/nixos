# home/maksim.nix
{ pkgs, variables, zenBrowserPackages, ... }: {
  imports = [
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
  ];

  home = {
    username      = variables.username;
    homeDirectory = "/home/${variables.username}";
    stateVersion  = variables.stateVersion;
  };

  home.packages = with pkgs; [
    # Terminal
    kitty

    # Browser (from zen-browser flake)
    # Use .default — check available attrs with: nix flake show github:0xc000022070/zen-browser-flake
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

  programs.home-manager.enable = true;
}
