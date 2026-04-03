# modules/home-manager/kitty.nix
{ ... }: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width   = 8;
      scrollback_lines       = 10000;
      enable_audio_bell      = false;
      confirm_os_window_close = 0;
    };
    themeFile = "Nord";

    # Keybindings that work in Russian layout (Cyrillic keysyms)
    keybindings = {
      "ctrl+shift+Cyrillic_es" = "copy_to_clipboard";           # ctrl+shift+c
      "ctrl+shift+Cyrillic_em" = "paste_from_clipboard";        # ctrl+shift+v
      "ctrl+shift+Cyrillic_te" = "new_tab";                     # ctrl+shift+t
      "ctrl+shift+Cyrillic_ze" = "close_tab";                   # ctrl+shift+w  (на русской w→ц, но close обычно q/w)
      "ctrl+shift+Cyrillic_tse" = "close_tab";                  # ctrl+shift+w (ц)
      "ctrl+shift+Cyrillic_ef" = "show_scrollback";             # ctrl+shift+f  (а→f)
      "ctrl+shift+Cyrillic_a" = "show_scrollback";              # ctrl+shift+a
    };
  };
}
