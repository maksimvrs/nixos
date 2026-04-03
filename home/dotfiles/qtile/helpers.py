"""Helper functions for media keys with dunst notifications."""

import subprocess

NOTIFICATION_TIMEOUT = "1500"
VOLUME_NOTIFICATION_ID = "91190"
MIC_NOTIFICATION_ID = "91191"
BRIGHTNESS_NOTIFICATION_ID = "91192"


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
