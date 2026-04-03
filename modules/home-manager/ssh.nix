# modules/home-manager/ssh.nix
{ ... }: {
  # SSH-агент управляется GNOME Keyring (разблокируется при логине через PAM).
  # Отдельный ssh-agent не нужен — GNOME Keyring предоставляет SSH_AUTH_SOCK.
  services.ssh-agent.enable = false;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };
}
