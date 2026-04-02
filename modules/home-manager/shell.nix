# modules/home-manager/shell.nix
{ variables, ... }: {
  programs.zsh = {
    enable            = true;
    dotDir            = ".config/zsh";
    enableCompletion  = true;
    autosuggestion.enable = true;
    autocd            = true;

    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake .#${variables.hostname}";
      ls         = "eza";
      ll         = "eza -la";
      cat        = "bat";
    };

    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" "docker" "fzf" ];
      theme   = "robbyrussell";
    };

    initContent = ''
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"
    '';
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
    BROWSER = "zen";
  };
}
