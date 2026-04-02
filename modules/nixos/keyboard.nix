# modules/nixos/keyboard.nix
{ ... }: {
  services.xserver.xkb = {
    layout  = "us,ru";
    options = "grp:alt_shift_toggle";
  };
}
