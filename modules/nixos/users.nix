# modules/nixos/users.nix
{ pkgs, variables, ... }:
{
  programs.zsh.enable = true;

  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.gitName;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
    initialPassword = "password";
  };
}
