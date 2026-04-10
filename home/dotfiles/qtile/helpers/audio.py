"""Volume controls via wpctl, with dunst notifications."""

from .notify import run_command, send_notification

VOLUME_NOTIFICATION_ID = "91190"


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
