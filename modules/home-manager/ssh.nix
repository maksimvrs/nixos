# modules/home-manager/ssh.nix
{ ... }: {
  # Запуск ssh-agent как systemd user service
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    # Автоматически добавлять ключ в агент при первом использовании
    addKeysToAgent = "yes";
  };
}
