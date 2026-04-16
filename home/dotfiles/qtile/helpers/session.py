"""Session controls: screen lock."""

import subprocess
import threading


def lock_screen(qtile):
    """Launch gtklock and block Qtile keybindings while locked."""
    core = qtile.core
    core._locked = True

    def _wait():
        proc = subprocess.Popen(["gtklock"])
        proc.wait()
        core._locked = False

    threading.Thread(target=_wait, daemon=True).start()
