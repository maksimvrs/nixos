"""Helper functions for Qtile."""


# ── Toggle Floating (centered) ────────────────────────────────────────────

FLOATING_WIDTH = 1200
FLOATING_HEIGHT = 800


def resize_and_center(win, screen, width=FLOATING_WIDTH, height=FLOATING_HEIGHT):
    """Set window size and center it on the given screen."""
    win.set_size_floating(width, height)
    x = screen.x + (screen.width - width) // 2
    y = screen.y + (screen.height - height) // 2
    win.set_position_floating(x, y)


def toggle_floating_centered(qtile):
    """Toggle floating with a default size, centered on screen."""
    win = qtile.current_window
    if not win:
        return
    if win.floating:
        win.toggle_floating()
    else:
        win.toggle_floating()
        resize_and_center(win, qtile.current_screen)


# ── Resize (floating-aware) ───────────────────────────────────────────────

FLOATING_RESIZE_STEP = 40

_TILED_RESIZE = {
    "left":  "shrink_main",
    "right": "grow_main",
    "down":  "grow",
    "up":    "shrink",
}

_FLOATING_RESIZE_DELTAS = {
    "left":  (-FLOATING_RESIZE_STEP, 0),
    "right": (FLOATING_RESIZE_STEP, 0),
    "up":    (0, -FLOATING_RESIZE_STEP),
    "down":  (0, FLOATING_RESIZE_STEP),
}


def resize_focused(qtile, direction):
    """Resize the focused window — dispatches to floating or layout resize."""
    win = qtile.current_window
    if not win:
        return
    if win.floating:
        dw, dh = _FLOATING_RESIZE_DELTAS[direction]
        win.resize_floating(dw, dh)
    else:
        getattr(qtile.current_layout, _TILED_RESIZE[direction])()

import subprocess

NOTIFICATION_TIMEOUT = "1500"
VOLUME_NOTIFICATION_ID = "91190"
MIC_NOTIFICATION_ID = "91191"
BRIGHTNESS_NOTIFICATION_ID = "91192"
POWER_PROFILE_NOTIFICATION_ID = "91193"


# ── Screen Lock ─────────────────────────────────────────────────────────

def lock_screen(qtile):
    """Launch gtklock and block Qtile keybindings while locked."""
    import threading

    core = qtile.core
    core._locked = True

    def _wait():
        proc = subprocess.Popen(["gtklock"])
        proc.wait()
        core._locked = False

    threading.Thread(target=_wait, daemon=True).start()


# ── Power Menu ──────────────────────────────────────────────────────────

POWER_MENU_ENTRIES = (
    "󰐥  Shutdown",
    "󰜉  Reboot",
    "󰌾  Lock",
    "󰍃  Logout",
)


def power_menu(qtile):
    """Show a wofi dmenu power menu and dispatch the chosen action."""
    import os
    import threading

    def _run():
        result = subprocess.run(
            [
                "wofi", "--dmenu",
                "--prompt", "Power",
                "--width", "320",
                "--height", "260",
            ],
            input="\n".join(POWER_MENU_ENTRIES),
            capture_output=True,
            text=True,
        )
        choice = result.stdout.strip()
        if not choice:
            return
        if "Shutdown" in choice:
            subprocess.Popen(["systemctl", "poweroff"])
        elif "Reboot" in choice:
            subprocess.Popen(["systemctl", "reboot"])
        elif "Lock" in choice:
            lock_screen(qtile)
        elif "Logout" in choice:
            subprocess.Popen(["loginctl", "terminate-user", os.environ["USER"]])

    threading.Thread(target=_run, daemon=True).start()

POWER_PROFILES = ["power-saver", "balanced", "performance"]
POWER_PROFILE_ICONS = {
    "power-saver": "🔋",
    "balanced": "⚖",
    "performance": "🚀",
}


def run_command(*command):
    """Run a shell command and return the result."""
    return subprocess.run(command, capture_output=True, text=True)


def send_notification(notification_id, title, body, value=None):
    """Send a dunst notification, optionally with a progress bar."""
    command = [
        "dunstify",
        "-r", notification_id,
        "-t", NOTIFICATION_TIMEOUT,
    ]
    if value is not None:
        command += ["-h", f"int:value:{value}"]
    command += [title, body]
    subprocess.Popen(command)


# ── Volume ───────────────────────────────────────────────────────────────

def _notify_volume():
    result = run_command("wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@")
    parts = result.stdout.strip().split()
    if len(parts) < 2:
        return
    percent = int(float(parts[1]) * 100)
    muted = "[MUTED]" in result.stdout
    icon = "🔇" if muted else "🔊"
    label = f"{percent}% [MUTED]" if muted else f"{percent}%"
    send_notification(VOLUME_NOTIFICATION_ID, f"{icon} Volume", label, value=percent)


def volume_up(qtile):
    run_command("wpctl", "set-volume", "-l", "1.0", "@DEFAULT_AUDIO_SINK@", "5%+")
    _notify_volume()


def volume_down(qtile):
    run_command("wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-")
    _notify_volume()


def volume_mute(qtile):
    run_command("wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle")
    _notify_volume()


# ── Microphone ───────────────────────────────────────────────────────────

def mic_mute(qtile):
    run_command("wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle")
    result = run_command("wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@")
    muted = "[MUTED]" in result.stdout
    icon = "🎤" if not muted else "🔇"
    label = "ON" if not muted else "MUTED"
    send_notification(MIC_NOTIFICATION_ID, f"{icon} Microphone", label)


# ── Brightness ───────────────────────────────────────────────────────────

def _notify_brightness():
    result = run_command("brightnessctl", "info")
    for line in result.stdout.splitlines():
        if "%" in line:
            percent_str = line.split("(")[-1].rstrip("%)")
            try:
                percent = int(percent_str)
                send_notification(
                    BRIGHTNESS_NOTIFICATION_ID,
                    "☀ Brightness",
                    f"{percent}%",
                    value=percent,
                )
                return
            except ValueError:
                pass


def brightness_up(qtile):
    run_command("brightnessctl", "set", "5%+")
    _notify_brightness()


def brightness_down(qtile):
    run_command("brightnessctl", "set", "5%-")
    _notify_brightness()


# ── Power Profile ───────────────────────────────────────────────────────

def get_power_profile():
    """Get current power profile name."""
    try:
        result = subprocess.run(
            ("powerprofilesctl", "get"),
            capture_output=True, text=True, timeout=2,
        )
        return result.stdout.strip()
    except (subprocess.TimeoutExpired, Exception):
        return ""


def power_profile_cycle(qtile):
    """Cycle to the next power profile and show notification."""
    current = get_power_profile()
    try:
        idx = POWER_PROFILES.index(current)
    except ValueError:
        idx = 0
    next_profile = POWER_PROFILES[(idx + 1) % len(POWER_PROFILES)]
    run_command("powerprofilesctl", "set", next_profile)
    icon = POWER_PROFILE_ICONS.get(next_profile, "⚡")
    send_notification(
        POWER_PROFILE_NOTIFICATION_ID,
        f"{icon} Power Profile",
        next_profile,
    )
