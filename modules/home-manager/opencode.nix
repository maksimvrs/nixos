# modules/home-manager/opencode.nix
{ pkgs, variables, ... }: {
  home.packages = [ pkgs.opencode ];

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama";
        options.baseURL = "http://localhost:11434/v1";
        models.${variables.ollamaModel}.name = "Qwen 2.5 Coder";
      };
    };
  };
}
