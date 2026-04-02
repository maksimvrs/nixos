# modules/nixos/networking.nix
{ variables, ... }: {
  networking.hostName = variables.hostname;
  networking.networkmanager.enable = true;
}
