# modules/home-manager/browser.nix
{ zenBrowserPackages, ... }: {
  home.packages = [
    # Use .default — check available attrs with: nix flake show github:0xc000022070/zen-browser-flake
    zenBrowserPackages.default
  ];
}
