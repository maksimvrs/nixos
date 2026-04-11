# modules/home-manager/claude.nix
{ pkgs, config, ... }:
let
  # --- Plugin sources ---
  superpowers-src = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37";
    hash = "sha256-hGEMwmSojy3cNtUQvB5djExlD39O2dwcnLOMUNaVIHg=";
  };

  claude-hud-src = pkgs.fetchFromGitHub {
    owner = "jarrodwatts";
    repo = "claude-hud";
    rev = "30e1dfe46ad7b9a39ca2a4df7c735aaa33a90fd9";
    hash = "sha256-75k+xUoKv+obYYYKujcbi+nutBSgqRA63zlh50M37Ko=";
  };

  # --- Marketplace sources ---
  superpowers-marketplace-src = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers-marketplace";
    rev = "8560ad09fb77947975294ce5d600840dce225a42";
    hash = "sha256-kKkOTPMtsWvKtfc0zIU78zlxY0FA11SjeE+/EHZRis0=";
  };

  claude-plugins-official-src = pkgs.fetchFromGitHub {
    owner = "anthropics";
    repo = "claude-plugins-official";
    rev = "b091cb4179d3b62a6e2a39910461c7ec7165b1ef";
    hash = "sha256-uKDVcw6C1uzpiIY+hjgHxr4AU9wM1KF7t3v6zd9XBHk=";
  };
in
{
  home.packages = [
    pkgs.claude-code
    pkgs.nodejs
  ];

  # --- Plugin cache (declarative) ---
  # Structure: ~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/
  home.file.".claude/plugins/cache/superpowers-marketplace/superpowers/5.0.7".source =
    superpowers-src;
  home.file.".claude/plugins/cache/claude-plugins-official/superpowers/5.0.7".source =
    superpowers-src;
  home.file.".claude/plugins/cache/claude-hud/claude-hud/0.0.11".source = claude-hud-src;

  # --- Marketplace repos ---
  home.file.".claude/plugins/marketplaces/superpowers-marketplace".source =
    superpowers-marketplace-src;
  home.file.".claude/plugins/marketplaces/claude-plugins-official".source =
    claude-plugins-official-src;
  home.file.".claude/plugins/marketplaces/claude-hud".source = claude-hud-src;

  # --- known_marketplaces.json ---
  home.file.".claude/plugins/known_marketplaces.json".text = builtins.toJSON {
    claude-plugins-official = {
      source = {
        source = "github";
        repo = "anthropics/claude-plugins-official";
      };
      installLocation = "/home/maksim/.claude/plugins/marketplaces/claude-plugins-official";
      lastUpdated = "2026-04-06T00:00:00.000Z";
    };
    superpowers-marketplace = {
      source = {
        source = "github";
        repo = "obra/superpowers-marketplace";
      };
      installLocation = "/home/maksim/.claude/plugins/marketplaces/superpowers-marketplace";
      lastUpdated = "2026-04-06T00:00:00.000Z";
    };
    claude-hud = {
      source = {
        source = "github";
        repo = "jarrodwatts/claude-hud";
      };
      installLocation = "/home/maksim/.claude/plugins/marketplaces/claude-hud";
      lastUpdated = "2026-04-06T00:00:00.000Z";
    };
  };

  # --- settings.json ---
  home.file.".claude/settings.json".text = builtins.toJSON {
    statusLine = {
      type = "command";
      command = "bash -c 'plugin_dir=$(ls -d \"\${CLAUDE_CONFIG_DIR:-$HOME/.claude}\"/plugins/cache/claude-hud/claude-hud/*/ 2>/dev/null | awk -F/ '\"'\"'{ print $(NF-1) \"\\t\" $(0) }'\"'\"' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | tail -1 | cut -f2-); exec \"${pkgs.nodejs}/bin/node\" \"\${plugin_dir}dist/index.js\"'";
    };
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
          repo = "obra/superpowers-marketplace";
        };
      };
      claude-hud = {
        source = {
          source = "github";
          repo = "jarrodwatts/claude-hud";
        };
      };
    };
  };
}
