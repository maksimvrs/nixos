# modules/nixos/users.nix
{ pkgs, variables, ... }: {
  programs.zsh.enable = true;

  users.users.${variables.username} = {
    isNormalUser = true;
    description  = variables.username;
    extraGroups  = [ "wheel" "networkmanager" "audio" "video" "docker" ];
    shell        = pkgs.zsh;
  };
}
