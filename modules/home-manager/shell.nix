# modules/home-manager/shell.nix
{
  variables,
  config,
  pkgs,
  ...
}:
let
  aiPrompt = builtins.concatStringsSep " " [
    "You generate shell commands for a NixOS system running zsh."
    "Output ONLY the command. No explanation, no markdown, no backticks, no commentary."
    "Rules:"
    "- If a tool is not installed, use 'nix shell nixpkgs#<package> -c <command>' or 'nix run nixpkgs#<package> -- <args>' to run it ad-hoc."
    "- Use coreutils/standard tools when possible."
    "- Prefer simple pipelines over complex one-liners."
    "- Use systemctl for services (systemd-based system)."
    "- Package manager is nix, not apt/pacman/etc."
    "- Current shell is zsh."
    "- Current working directory:"
  ];

  aiFunction = ''
    # Convert natural language to shell command via Claude Code, place into zsh input
    ai() {
      [[ -z "$*" ]] && echo "Usage: ai <description>" && return 1
      local result
      result=$(claude --model haiku -p --max-turns 3 "${aiPrompt} $PWD. Query: $*" 2>/dev/null)
      if [[ $? -eq 0 && -n "$result" ]]; then
        print -z "$result"
      else
        echo "Failed to generate command"
      fi
    }
  '';
in
{
  programs = {
    zsh = {
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

    starship = {
      enable = true;
    };

    btop = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
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
