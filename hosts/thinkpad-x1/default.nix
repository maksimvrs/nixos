# hosts/thinkpad-x1/default.nix
{ variables, ... }: {
  imports = [
    ../../modules/nixos/boot.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/keyboard.nix
    ../../modules/nixos/sops.nix
    ../../modules/nixos/vpn.nix
  ];

  system.stateVersion = variables.stateVersion;
}
