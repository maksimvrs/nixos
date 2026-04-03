# Qtile config — entry point
# Each module is imported so qtile picks up the top-level names it expects.

import os
import sys

# __file__ resolves into the nix store (symlink target), but sibling
# modules live in ~/.config/qtile/ — add that directory to sys.path.
_config_dir = os.path.expanduser("~/.config/qtile")
if _config_dir not in sys.path:
    sys.path.insert(0, _config_dir)

from groups import groups  # noqa: F401 (also extends keys)
from keys import keys  # noqa: F401
from layouts import layouts  # noqa: F401
from bar import screens, extension_defaults  # noqa: F401
from mouse import mouse  # noqa: F401
from theme import widget_defaults  # noqa: F401
import hooks  # noqa: F401 (registers @hook.subscribe handlers)
from settings import (  # noqa: F401
    dgroups_key_binder,
    dgroups_app_rules,
    follow_mouse_focus,
    bring_front_click,
    floats_kept_above,
    cursor_warp,
    auto_fullscreen,
    focus_on_window_activation,
    reconfigure_screens,
    auto_minimize,
    wmname,
    floating_layout,
    wl_input_rules,
)
