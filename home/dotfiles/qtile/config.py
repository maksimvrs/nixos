from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"  # Super key
terminal = "kitty"

# ---------------------------------------------------------------------------
# Key bindings
# ---------------------------------------------------------------------------
keys = [
    # Window focus
    Key([mod], "h", lazy.layout.left(),  desc="Focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Focus right"),
    Key([mod], "j", lazy.layout.down(),  desc="Focus down"),
    Key([mod], "k", lazy.layout.up(),    desc="Focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Focus next window"),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),  desc="Move left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),  desc="Move down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(),    desc="Move up"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(),  desc="Grow left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),  desc="Grow down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(),    desc="Grow up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset sizes"),

    # Toggle layouts
    Key([mod], "Tab",    lazy.next_layout(),        desc="Next layout"),
    Key([mod], "f",      lazy.window.toggle_fullscreen(), desc="Fullscreen"),
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc="Toggle floating"),

    # Launch
    Key([mod], "Return", lazy.spawn(terminal),      desc="Terminal"),
    Key([mod], "d",      lazy.spawn("rofi -show drun"), desc="Launcher"),

    # Session
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Exit qtile"),
]

# ---------------------------------------------------------------------------
# Groups (workspaces)
# ---------------------------------------------------------------------------
groups = [Group(i) for i in "123456789"]

for g in groups:
    keys.extend([
        Key([mod], g.name, lazy.group[g.name].toscreen(),
            desc=f"Switch to group {g.name}"),
        Key([mod, "shift"], g.name, lazy.window.togroup(g.name, switch_group=True),
            desc=f"Move window to group {g.name}"),
    ])

# ---------------------------------------------------------------------------
# Layouts
# ---------------------------------------------------------------------------
layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": "#7aa2f7",
    "border_normal": "#1a1b26",
}

layouts = [
    layout.Columns(**layout_theme),
    layout.Max(**layout_theme),
    layout.MonadTall(**layout_theme),
]

# ---------------------------------------------------------------------------
# Bar / Widgets
# ---------------------------------------------------------------------------
widget_defaults = dict(
    font="sans",
    fontsize=14,
    padding=6,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    highlight_method="line",
                    active="#c0caf5",
                    inactive="#565f89",
                    this_current_screen_border="#7aa2f7",
                ),
                widget.Spacer(length=8),
                widget.WindowName(foreground="#a9b1d6"),
                widget.Systray(),
                widget.Spacer(length=8),
                widget.PulseVolume(fmt="Vol: {}"),
                widget.Spacer(length=8),
                widget.Battery(format="Bat: {percent:2.0%}"),
                widget.Spacer(length=8),
                widget.Clock(format="%a %d %b  %H:%M"),
            ],
            size=28,
            background="#1a1b26",
        ),
    ),
]

# ---------------------------------------------------------------------------
# Mouse (floating drag / resize)
# ---------------------------------------------------------------------------
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),     start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# ---------------------------------------------------------------------------
# General settings
# ---------------------------------------------------------------------------
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
    ],
    **layout_theme,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "qtile"
