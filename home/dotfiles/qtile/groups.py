"""Qtile workspace groups."""

from libqtile.config import Group, Key
from libqtile.lazy import lazy

from keys import keys, MOD

groups = [Group(name) for name in "1234567890"]

for group in groups:
    keys.extend([
        Key([MOD], group.name, lazy.group[group.name].toscreen(),
            desc=f"Switch to group {group.name}"),
        Key([MOD, "shift"], group.name, lazy.window.togroup(group.name, switch_group=True),
            desc=f"Move window to group {group.name}"),
    ])
