"""Microphone mute toggle via wpctl, with dunst notification."""

from .notify import run_command, send_notification

MIC_NOTIFICATION_ID = "91191"


def mic_mute(qtile):
    run_command("wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle")
    result = run_command("wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@")
    muted = "[MUTED]" in result.stdout
    icon = "🎤" if not muted else "🔇"
    label = "ON" if not muted else "MUTED"
    send_notification(MIC_NOTIFICATION_ID, f"{icon} Microphone", label)
