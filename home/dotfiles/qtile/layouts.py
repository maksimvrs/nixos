from libqtile import layout

from theme import layout_theme

layouts = [
    layout.MonadTall(**layout_theme),
    layout.TreeTab(**layout_theme),
]
