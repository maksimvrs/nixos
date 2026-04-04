"""Qtile keybindings."""

from libqtile.config import Key
from libqtile.lazy import lazy

from helpers import (
    brightness_down,
    brightness_up,
    mic_mute,
    power_profile_cycle,
    volume_down,
    volume_mute,
    volume_up,
)

MOD = "mod4"
TERMINAL = "kitty"

# QWERTY → ЙЦУКЕН mapping (XKB Cyrillic keysym names).
# Used to duplicate all letter-based keybindings for Russian layout.
ENGLISH_TO_RUSSIAN = {
    "q": "Cyrillic_shorti", "w": "Cyrillic_tse", "e": "Cyrillic_u",
    "r": "Cyrillic_ka",     "t": "Cyrillic_ie",  "y": "Cyrillic_en",
    "u": "Cyrillic_ghe",    "i": "Cyrillic_sha",  "o": "Cyrillic_shcha",
    "p": "Cyrillic_ze",
    "a": "Cyrillic_ef",     "s": "Cyrillic_yeru",  "d": "Cyrillic_ve",
    "f": "Cyrillic_a",      "g": "Cyrillic_pe",    "h": "Cyrillic_er",
    "j": "Cyrillic_o",      "k": "Cyrillic_el",    "l": "Cyrillic_de",
    "z": "Cyrillic_ya",     "x": "Cyrillic_che",   "c": "Cyrillic_es",
    "v": "Cyrillic_em",     "b": "Cyrillic_i",     "n": "Cyrillic_te",
    "m": "Cyrillic_softsign",
}

keys = [
    # ── Window focus ──────────────────────────────────────────────────
    Key([MOD], "h", lazy.layout.left(), desc="Focus left"),
    Key([MOD], "l", lazy.layout.right(), desc="Focus right"),
    Key([MOD], "j", lazy.layout.down(), desc="Focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Focus up"),

    # ── Move windows ──────────────────────────────────────────────────
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move left"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="Move right"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move up"),

    # ── Resize windows ────────────────────────────────────────────────
    Key([MOD, "control"], "h", lazy.layout.shrink_main(), desc="Resize left"),
    Key([MOD, "control"], "l", lazy.layout.grow_main(), desc="Resize right"),
    Key([MOD, "control"], "j", lazy.layout.grow(), desc="Resize down"),
    Key([MOD, "control"], "k", lazy.layout.shrink(), desc="Resize up"),
    Key([MOD], "equal", lazy.layout.normalize(), desc="Reset sizes"),

    # ── Layouts ───────────────────────────────────────────────────────
    Key([MOD], "Tab", lazy.next_layout(), desc="Next layout"),
    Key([MOD], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen"),
    Key([MOD, "shift"], "f", lazy.window.toggle_floating(), desc="Toggle floating"),

    # ── Launch ────────────────────────────────────────────────────────
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Terminal"),
    Key([MOD], "space", lazy.spawn("wofi --show drun"), desc="Launcher"),
    Key([MOD], "d", lazy.spawn("wofi --show drun"), desc="Launcher"),

    # ── Clipboard ─────────────────────────────────────────────────────
    Key([MOD], "v", lazy.spawn("copyq toggle"), desc="Clipboard history"),

    # ── Network ───────────────────────────────────────────────────────
    Key([MOD], "n", lazy.spawn("nm-connection-editor"), desc="Network settings"),

    # ── Screenshot (grim + slurp) ─────────────────────────────────────
    Key([], "Print",
        lazy.spawn("sh -c ~/.config/qtile/screenshot.sh"),
        desc="Screenshot region"),
    Key(["shift"], "Print",
        lazy.spawn("sh -c '~/.config/qtile/screenshot.sh full'"),
        desc="Screenshot full"),

    # ── Session ───────────────────────────────────────────────────────
    Key([MOD], "q", lazy.window.kill(), desc="Kill window"),
    Key([MOD, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([MOD, "shift"], "e", lazy.shutdown(), desc="Exit qtile"),

    # ── Volume ────────────────────────────────────────────────────────
    Key([], "XF86AudioRaiseVolume", lazy.function(volume_up), desc="Volume up"),
    Key([], "XF86AudioLowerVolume", lazy.function(volume_down), desc="Volume down"),
    Key([], "XF86AudioMute", lazy.function(volume_mute), desc="Mute"),

    # ── Microphone (ThinkPad) ─────────────────────────────────────────
    Key([], "XF86AudioMicMute", lazy.function(mic_mute), desc="Mic mute"),

    # ── Brightness ────────────────────────────────────────────────────
    Key([], "XF86MonBrightnessUp", lazy.function(brightness_up), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.function(brightness_down), desc="Brightness down"),

    # ── Power Profile ─────────────────────────────────────────────────
    Key([MOD], "b", lazy.function(power_profile_cycle), desc="Cycle power profile"),
]

# Duplicate letter-based bindings for Russian layout so keybindings
# work regardless of the active XKB group.
keys.extend(
    Key(binding.modifiers, ENGLISH_TO_RUSSIAN[binding.key], *binding.commands, desc=binding.desc)
    for binding in keys
    if binding.key in ENGLISH_TO_RUSSIAN
)
