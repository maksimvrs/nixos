# modules/home-manager/zen-browser.nix
{ firefoxAddons, ... }: {
  programs.zen-browser = {
    enable = true;
    profiles.default = {
      settings = {
        "privacy.resistFingerprinting" = true;
      };
      extensions.packages = with firefoxAddons; [
        ublock-origin
        sponsorblock
        bitwarden
      ];
    };
  };
}
