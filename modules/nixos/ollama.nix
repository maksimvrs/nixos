# modules/nixos/ollama.nix
{ variables, ... }:
{
  services.ollama = {
    enable = true;
    loadModels = [ variables.ollamaModel ];
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "5m"; # unload models after 5 minutes of inactivity
    };
  };
}
