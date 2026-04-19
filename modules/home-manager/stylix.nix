# modules/home-manager/stylix.nix
#
# Stylix is the single source of truth for app color themes.
# Noctalia keeps managing its own bar colors via predefinedScheme = "Catppuccin".
{ pkgs, ... }: {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes.applications = 10;
      sizes.terminal = 12;
    };

    # Avoid `nixpkgs.overlays` inside home-manager (breaks `useGlobalPkgs`).
    overlays.enable = false;

    targets.zen-browser.profileNames = [ "default" ];
  };

  gtk.gtk4.theme = null;
}
