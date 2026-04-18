# modules/home-manager/noctalia.nix
#
# Noctalia desktop shell — bar, notifications, widgets.
# Enabled via the noctalia flake homeModule (added to sharedModules in flake.nix).
_: {
  programs.noctalia-shell.enable = true;
}
