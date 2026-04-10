#!/usr/bin/env python3
"""Print all qtile keybindings as Markdown.

Loads the same `keys.py`/`groups.py` qtile itself uses, so the output is
always in sync with what's actually bound. Stubs out `libqtile` imports so
this runs under plain system python (no qtile runtime needed).
"""

import sys
import types
from pathlib import Path


# ── libqtile stubs ────────────────────────────────────────────────────────
# keys.py / groups.py only touch a few attributes on these classes, so a
# minimal stand-in is enough for the config to import cleanly.

class _Key:
    def __init__(self, modifiers, key, *commands, desc="", **_kw):
        self.modifiers = modifiers
        self.key = key
        self.commands = commands
        self.desc = desc


class _Group:
    def __init__(self, name, *_a, **_kw):
        self.name = name


class _Lazy:
    # Absorbs any attribute / call / subscript because keys.py wraps our
    # helpers in lazy.function(...).foo()[bar] chains at import time, and we
    # don't care what any of it returns — only the Key metadata.
    def __getattr__(self, _name): return self
    def __call__(self, *_a, **_kw): return self
    def __getitem__(self, _k): return self


_config = types.ModuleType("libqtile.config")
_config.Key = _Key
_config.Group = _Group
_lazy_mod = types.ModuleType("libqtile.lazy")
_lazy_mod.lazy = _Lazy()

sys.modules["libqtile"] = types.ModuleType("libqtile")
sys.modules["libqtile.config"] = _config
sys.modules["libqtile.lazy"] = _lazy_mod


# ── Load the real config modules ──────────────────────────────────────────

sys.path.insert(0, str(Path(__file__).parent))

from keys import RUSSIAN_KEYSYMS, keys  # noqa: E402
import groups  # noqa: E402,F401  — side effect: appends group bindings to `keys`


# ── Pretty printing ───────────────────────────────────────────────────────

MOD_DISPLAY = {
    "mod4": "Super",
    "mod1": "Alt",
    "shift": "Shift",
    "control": "Ctrl",
}

KEY_DISPLAY = {
    "Return": "Enter",
    "space": "Space",
    "equal": "=",
    "Print": "PrtSc",
    "XF86AudioRaiseVolume": "Volume Up",
    "XF86AudioLowerVolume": "Volume Down",
    "XF86AudioMute": "Mute",
    "XF86AudioMicMute": "Mic Mute",
    "XF86MonBrightnessUp": "Brightness Up",
    "XF86MonBrightnessDown": "Brightness Down",
}


def format_mods(mods):
    return " + ".join(MOD_DISPLAY.get(m, m) for m in mods)


def format_key(k):
    if k in KEY_DISPLAY:
        return KEY_DISPLAY[k]
    return k.upper() if len(k) == 1 else k


def format_binding(key):
    parts = [format_mods(key.modifiers)] if key.modifiers else []
    parts.append(format_key(key.key))
    return " + ".join(parts)


def main():
    buckets = {}
    for k in keys:
        if k.key in RUSSIAN_KEYSYMS:
            continue
        buckets.setdefault(tuple(k.modifiers), []).append(k)

    out = ["# Qtile Keybindings", ""]
    # no-mod → single-mod → combos
    for mods in sorted(buckets, key=lambda m: (len(m), m)):
        out.append(f"## {format_mods(mods) if mods else 'No modifier'}")
        out.append("")
        out.append("| Keys | Action |")
        out.append("|------|--------|")
        for k in buckets[mods]:
            out.append(f"| `{format_binding(k)}` | {k.desc} |")
        out.append("")

    print("\n".join(out))


if __name__ == "__main__":
    main()
