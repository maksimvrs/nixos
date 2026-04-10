"""Power profile cycling via powerprofilesctl, with dunst notifications."""

import subprocess

from .notify import run_command, send_notification

POWER_PROFILE_NOTIFICATION_ID = "91193"

POWER_PROFILES = ["power-saver", "balanced", "performance"]
POWER_PROFILE_ICONS = {
    "power-saver": "🔋",
    "balanced": "⚖",
    "performance": "🚀",
}


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
