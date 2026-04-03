# modules/home-manager/shell.nix
{ variables, config, ... }: {
  programs.zsh = {
    enable            = true;
    dotDir            = "${config.xdg.configHome}/zsh";
    enableCompletion  = true;
    autosuggestion.enable = true;
    autocd            = true;

    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#${variables.hostname}";
    };

    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" "fzf" ];
      theme   = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.direnv = {
    enable                = true;
    enableZshIntegration  = true;
    nix-direnv.enable     = true;
  };

  home.sessionVariables = {
    EDITOR  = "nvim";
    VISUAL  = "nvim";
    TERM    = "kitty";
    BROWSER = "zen-browser";
  };
}
