"""Qtile lifecycle hooks — autostart applications."""

import os
import subprocess

from libqtile import hook


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
