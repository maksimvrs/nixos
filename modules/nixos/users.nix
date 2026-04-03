# modules/nixos/users.nix
{ pkgs, config, variables, ... }: {
  programs.zsh.enable = true;

  users.users.${variables.username} = {
    isNormalUser       = true;
    description        = variables.gitName;
    extraGroups        = [ "wheel" "networkmanager" "audio" "video" ];
    shell              = pkgs.zsh;
    hashedPasswordFile = config.age.secrets.maksim-password.path;
  };
}
