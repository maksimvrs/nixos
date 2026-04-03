# modules/home-manager/dunst.nix
#
# Dunst notification daemon — Tokyo Night theme.
{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Appearance
        width = 350;
        height = 150;
        offset = "20x50";
        origin = "top-right";
        corner_radius = 8;
        frame_width = 2;
        frame_color = "#7aa2f7";
        separator_color = "frame";
        font = "FiraCode Nerd Font 11";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        icon_position = "left";
        max_icon_size = 48;
        padding = 12;
        horizontal_padding = 14;
        text_icon_padding = 12;

        # Behavior
        sort = "yes";
        indicate_hidden = "yes";
        show_age_threshold = 60;
        word_wrap = "yes";
        idle_threshold = 120;
        show_indicators = "yes";

        # Progress bar (for volume/brightness)
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_corner_radius = 3;

        # Mouse actions
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#1a1b26";
        foreground = "#a9b1d6";
        frame_color = "#565f89";
        timeout = 5;
      };

      urgency_normal = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        frame_color = "#7aa2f7";
        timeout = 8;
      };

      urgency_critical = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        frame_color = "#f7768e";
        timeout = 0;
      };
    };
  };
}
