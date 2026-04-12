# modules/home-manager/shell.nix
{
  variables,
  config,
  pkgs,
  ...
}:
let
  aiFunction = ''
    # Convert natural language to shell command via Claude Code, place into zsh input
    ai() {
      [[ -z "$*" ]] && echo "Usage: ai <description>" && return 1
      local result
      result=$(claude -p "Convert this to a single shell command. Output ONLY the command, nothing else. No explanation, no markdown, no backticks. Query: $*" 2>/dev/null)
      if [[ $? -eq 0 && -n "$result" ]]; then
        print -z "$result"
      else
        echo "Failed to generate command"
      fi
    }
  '';
in
{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      nix-switch = "sudo nixos-rebuild switch --flake /etc/nixos#${variables.hostname}";
      oil = "nvim -c Oil";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "fzf"
      ];
      theme = "robbyrussell";
    };

    initContent = ''
      ${aiFunction}
    '';

    plugins = [
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
    ];
  };

  programs.starship = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = [ pkgs.zsh-completions ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERM = "kitty";
    BROWSER = "zen-beta";
    SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
  };
}
