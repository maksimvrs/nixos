# modules/home-manager/claude.nix
{ pkgs, config, ... }: {
  home.packages = [ pkgs.claude-code ];

  home.file.".claude/settings.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Bash(git:*)"
        "Bash(uv:*)"
        "Bash(python:*)"
        "Bash(python3:*)"
        "Bash(grep:*)"
        "Bash(sed:*)"
        "Bash(awk:*)"
        "Bash(find:*)"
        "Bash(ls:*)"
        "Bash(cat:*)"
        "Bash(wc:*)"
        "Bash(curl:*)"
        "Bash(xargs:*)"
        "Bash(mkdir:*)"
        "Bash(cp:*)"
        "Bash(mv:*)"
        "Bash(touch:*)"
        "Bash(echo:*)"
        "Bash(head:*)"
        "Bash(tail:*)"
        "Bash(sort:*)"
        "Bash(uniq:*)"
        "Bash(jq:*)"
        "Bash(diff:*)"
        "Bash(which:*)"
        "Bash(ps:*)"
        "Bash(kill:*)"
        "Bash(docker:*)"
        "Bash(docker-compose:*)"
        "Bash(nix:*)"
        "Edit"
        "Write"
        "MultiEdit"
        "WebSearch"
        "WebFetch"
      ];
    };
    enabledPlugins = {
      "superpowers@superpowers-marketplace" = true;
      "claude-hud@claude-hud" = true;
    };
    extraKnownMarketplaces = {
      superpowers-marketplace = {
        source = {
          source = "github";
          repo   = "obra/superpowers-marketplace";
        };
      };
      claude-hud = {
        source = {
          source = "github";
          repo   = "jarrodwatts/claude-hud";
        };
      };
    };
  };
}
