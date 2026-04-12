# modules/home-manager/kitty.nix
_: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width = 8;
      scrollback_lines = 10000;
      enable_audio_bell = true;
      confirm_os_window_close = 0;
    };
    themeFile = "Nord";

    keybindings = { };

    extraConfig = ''
      map ctrl+shift+с copy_to_clipboard
      map ctrl+shift+м paste_from_clipboard
      map ctrl+shift+е new_tab
      map ctrl+shift+ц close_tab
    '';
  };
}
