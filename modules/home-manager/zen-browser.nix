# modules/home-manager/zen-browser.nix
# Extensions are force-installed via Firefox policies on first browser launch.
# Zen Browser reads policies from ~/.zen/distribution/policies.json
{ zenBrowserPackages, ... }: {
  home.packages = [ zenBrowserPackages.default ];

  home.file.".zen/distribution/policies.json".text = builtins.toJSON {
    policies = {
      ExtensionSettings = {
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url        = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode  = "force_installed";
        };
        # SponsorBlock
        "sponsorBlocker@ajay.app" = {
          install_url        = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode  = "force_installed";
        };
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url        = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode  = "force_installed";
        };
      };
    };
  };
}
