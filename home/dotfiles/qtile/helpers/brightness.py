"""Brightness controls via brightnessctl, with dunst notifications."""

from .notify import run_command, send_notification

BRIGHTNESS_NOTIFICATION_ID = "91192"


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
