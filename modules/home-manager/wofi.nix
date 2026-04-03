# modules/home-manager/wofi.nix
#
# Wofi — Wayland-native application launcher, Tokyo Night theme.
{ pkgs, ... }: {
  home.packages = [ pkgs.wofi ];

  xdg.configFile."wofi/config".text = ''
    show=drun
    width=550
    height=400
    always_parse_args=true
    show_all=true
    print_command=true
    layer=overlay
    insensitive=true
    prompt=Search...
    allow_markup=true
    allow_images=true
    image_size=28
    no_actions=true
    halign=center
    orientation=vertical
    content_halign=fill
    columns=1
    key_expand=Tab
  '';

  xdg.configFile."wofi/style.css".text = ''
    /* ── Tokyo Night ── */

    * {
      font-family: "FiraCode Nerd Font", sans-serif;
      font-size: 14px;
    }

    window {
      margin: 0;
      border: 2px solid #7aa2f7;
      border-radius: 12px;
      background-color: #1a1b26;
    }

    #input {
      margin: 12px 12px 6px 12px;
      padding: 10px 16px;
      border: none;
      border-radius: 8px;
      background-color: #24283b;
      color: #c0caf5;
      caret-color: #7aa2f7;
    }

    #input:focus {
      outline: none;
      box-shadow: 0 0 0 2px rgba(122, 162, 247, 0.3);
    }

    #outer-box {
      margin: 0;
      padding: 0;
      background-color: transparent;
    }

    #inner-box {
      margin: 6px 8px 10px 8px;
      background-color: transparent;
    }

    #scroll {
      margin: 0;
    }

    #entry {
      padding: 6px 10px;
      border-radius: 8px;
    }

    #entry:selected {
      background-color: #283457;
      outline: none;
    }

    #img {
      margin-right: 10px;
    }

    #text {
      margin: 0;
      padding: 2px 4px;
      color: #a9b1d6;
    }

    #text:selected,
    #entry:selected #text {
      color: #7dcfff;
      font-weight: bold;
    }
  '';
}
