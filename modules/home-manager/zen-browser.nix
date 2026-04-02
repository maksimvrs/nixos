# modules/home-manager/zen-browser.nix
{ firefoxAddons, ... }: {
  programs.zen-browser = {
    enable = true;
    profiles.default.extensions.packages = with firefoxAddons; [
      ublock-origin
      sponsorblock
      bitwarden
    ];
  };
}
