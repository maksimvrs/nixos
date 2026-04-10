"""Shared subprocess and dunst notification utilities."""

import subprocess

NOTIFICATION_TIMEOUT = "1500"


def run_command(*command):
    """Run a shell command and return the completed process."""
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
