"""Session controls: screen lock and wofi power menu."""

import os
import subprocess
import threading

POWER_MENU_ENTRIES = (
    "󰐥  Shutdown",
    "󰜉  Reboot",
    "󰌾  Lock",
    "󰍃  Logout",
)


def lock_screen(qtile):
    """Launch gtklock and block Qtile keybindings while locked."""
    core = qtile.core
    core._locked = True

    def _wait():
        proc = subprocess.Popen(["gtklock"])
        proc.wait()
        core._locked = False

    threading.Thread(target=_wait, daemon=True).start()


def power_menu(qtile):
    """Show a wofi dmenu power menu and dispatch the chosen action."""

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
