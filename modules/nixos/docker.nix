# modules/nixos/docker.nix
{ variables, ... }: {
  virtualisation.docker.enable = true;

  users.users.${variables.username}.extraGroups = [ "docker" ];
}
