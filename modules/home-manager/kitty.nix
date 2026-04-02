# modules/home-manager/kitty.nix
{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 13;
    };
    settings = {
      window_padding_width   = 8;
      scrollback_lines       = 10000;
      enable_audio_bell      = false;
      confirm_os_window_close = 0;
    };
    themeFile = "Nord";
  };
}
