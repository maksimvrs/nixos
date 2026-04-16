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

# Mapping from ACPI platform_profile names to powerprofilesctl names
_ACPI_TO_PPD = {
    "low-power": "power-saver",
    "balanced": "balanced",
    "performance": "performance",
}

_SYSFS_PROFILE = "/sys/firmware/acpi/platform_profile"


def get_power_profile():
    """Get current power profile name (reads sysfs, no subprocess)."""
    try:
        with open(_SYSFS_PROFILE) as f:
            acpi_name = f.read().strip()
        return _ACPI_TO_PPD.get(acpi_name, acpi_name)
    except OSError:
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
