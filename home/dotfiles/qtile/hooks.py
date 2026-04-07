"""Qtile lifecycle hooks — autostart applications."""

import os
import subprocess

from libqtile import hook
from libqtile.backend.wayland.core import Core

from helpers import resize_and_center

# Guard against double-patching on config reload: save the real method
# only once, so subsequent reloads don't wrap the wrapper.
if not hasattr(Core, '_original_handle_keyboard_key'):
    Core._original_handle_keyboard_key = Core.handle_keyboard_key

    def _locked_handle_key(self, keysym, mask):
        if getattr(self, '_locked', False):
            return False
        return Core._original_handle_keyboard_key(self, keysym, mask)

    Core.handle_keyboard_key = _locked_handle_key


@hook.subscribe.startup_once
def autostart():
    """Start background services once on first login."""
    apps = [
        ["swaybg", "-i", os.path.expanduser("~/.config/qtile/wallpaper.jpg"), "-m", "fill"],
        ["dunst"],
        ["nm-applet", "--indicator"],
        ["copyq", "--start-server"],
    ]
    for cmd in apps:
        subprocess.Popen(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


@hook.subscribe.client_new
def force_nmtui_size(client):
    """Force nmtui to a fixed size every time it opens."""
    if client.name == "nmtui":
        resize_and_center(client, client.qtile.current_screen)


@hook.subscribe.client_managed
def focus_new_window(client):
    """Switch to the group of a newly opened window and focus it."""
    if client.group:
        client.group.toscreen()
        client.focus()
