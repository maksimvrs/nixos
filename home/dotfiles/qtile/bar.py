"""Qtile status bar configuration."""

import subprocess

from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy

from theme import colors, widget_defaults

extension_defaults = widget_defaults.copy()

# XKB keycode for 'q' (evdev 16 + 8 offset) and its Latin keysym.
# Used to detect the active keyboard layout via the compositor's XKB state.
XKB_KEYCODE_Q = 24
XKB_KEYSYM_LATIN_Q = 0x71


def get_keyboard_layout():
    """Query current XKB layout group via qtile's cffi bindings."""
    try:
        from libqtile import qtile
        from libqtile.backend.wayland._ffi import lib

        keysym = lib.qw_server_get_sym_from_code(qtile.core.qw, XKB_KEYCODE_Q)
        return "⌨ EN" if keysym == XKB_KEYSYM_LATIN_Q else "⌨ RU"
    except Exception:
        return "⌨ ??"


def make_separator():
    """Create a visual separator between bar widgets."""
    return widget.TextBox(text="│", foreground=colors["inactive"], padding=6)


def get_vpn_status():
    """Check for active VPN (wireguard or tun interfaces)."""
    for interface_type in ("wireguard", "tun"):
        try:
            output = subprocess.check_output(
                ["ip", "-brief", "link", "show", "type", interface_type],
                stderr=subprocess.DEVNULL,
                text=True,
            ).strip()
            if output:
                return "🔒 ON"
        except (subprocess.CalledProcessError, FileNotFoundError):
            pass
    return "🔓 OFF"


screens = [
    Screen(
        top=bar.Bar(
            [
                # ── Left ──────────────────────────────────────────
                widget.GroupBox(
                    highlight_method="line",
                    active=colors["fg"],
                    inactive=colors["inactive"],
                    this_current_screen_border=colors["accent"],
                    urgent_border=colors["red"],
                    rounded=False,
                    disable_drag=True,
                ),
                make_separator(),
                widget.CurrentLayout(foreground=colors["magenta"]),
                make_separator(),
                widget.WindowName(foreground=colors["fg_dim"], max_chars=50),

                widget.Spacer(),

                # ── System resources ──────────────────────────────
                widget.DF(
                    visible_on_warn=False,
                    partition="/",
                    format="💿 {uf:.0f}{m} ({r:.0f}%)",
                    foreground=colors["cyan"],
                    warn_color=colors["red"],
                    warn_space=10,
                    update_interval=300,
                ),
                make_separator(),
                widget.Memory(
                    format="🧠 {MemUsed:.1f}{mm}/{MemTotal:.1f}{mm}",
                    foreground=colors["cyan"],
                    measure_mem="G",
                ),
                make_separator(),

                # ── Hardware ──────────────────────────────────────
                widget.PulseVolume(
                    fmt="🔊 {}",
                    foreground=colors["green"],
                ),
                make_separator(),
                widget.Backlight(
                    backlight_name="intel_backlight",
                    format="☀ {percent:2.0%}",
                    foreground=colors["yellow"],
                    change_command=None,
                ),
                make_separator(),
                widget.Battery(
                    format="{char} {percent:2.0%}",
                    charge_char="🔌",
                    discharge_char="🔋",
                    full_char="✔",
                    empty_char="🪦",
                    not_charging_char="🔌",
                    unknown_char="?",
                    foreground=colors["green"],
                    low_foreground=colors["red"],
                    low_percentage=0.15,
                    notify_below=10,
                    update_interval=30,
                ),
                make_separator(),

                # ── Network ───────────────────────────────────────
                widget.GenPollText(
                    func=get_vpn_status,
                    update_interval=5,
                    foreground=colors["magenta"],
                ),
                make_separator(),
                widget.Wlan(
                    interface="wlp0s20f3",
                    format="📶 {essid}",
                    disconnected_message="📶 OFF",
                    foreground=colors["accent"],
                    update_interval=5,
                    mouse_callbacks={
                        "Button1": lazy.spawn("nm-connection-editor"),
                    },
                ),
                make_separator(),

                # ── Input ─────────────────────────────────────────
                widget.GenPollText(
                    func=get_keyboard_layout,
                    update_interval=0.1,
                    foreground=colors["orange"],
                ),
                make_separator(),

                # ── System tray ───────────────────────────────────
                widget.StatusNotifier(
                    icon_size=18,
                    padding=4,
                ),
                make_separator(),

                # ── Clock ─────────────────────────────────────────
                widget.Clock(
                    format="🕒 %a %d %b %H:%M:%S",
                    foreground=colors["fg"],
                ),
                widget.Spacer(length=6),
            ],
            size=30,
            background=colors["bg"],
            margin=[0, 0, 0, 0],
        ),
    ),
]
