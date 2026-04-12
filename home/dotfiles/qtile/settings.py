from libqtile import layout
from libqtile.config import Match
from libqtile.backend.wayland.inputs import InputConfig

from theme import layout_theme

dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "focus"
reconfigure_screens = True
auto_minimize = True
wmname = "qtile"

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="copyq"),
        Match(wm_class="CopyQ"),
        Match(wm_class="com.github.hluk.copyq"),
        Match(title="CopyQ"),
        Match(wm_class="nm-connection-editor"),
        Match(wm_class=".nm-connection-editor-wrapped"),
        Match(title="nmtui"),
        Match(title="keybindings"),
    ],
    **layout_theme,
)

wl_input_rules = {
    "type:touchpad": InputConfig(
        natural_scroll=True,
        tap=True,
    ),
    "type:pointer": InputConfig(
        natural_scroll=True,
    ),
    "*": InputConfig(
        kb_layout="us,ru",
        kb_options="grp:alt_shift_toggle",
    ),
}
