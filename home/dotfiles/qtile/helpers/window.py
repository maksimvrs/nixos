"""Floating window helpers: sizing, centering, and floating-aware resize."""

FLOATING_WIDTH = 1200
FLOATING_HEIGHT = 800
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
