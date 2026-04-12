# modules/nixos/keyboard.nix
_: {
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };
}
