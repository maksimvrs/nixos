# modules/nixos/docker.nix
{ variables, ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    dns = [
      "10.149.10.5"
      "1.1.1.1"
    ];
  };

  users.users.${variables.username}.extraGroups = [ "docker" ];
}
