# Niri + Noctalia Setup

Add Niri (scrolling tiling Wayland compositor) and Noctalia (desktop shell / status bar) alongside existing Qtile, selectable from SDDM at login.

## Scope

Basic, working setup with default Niri keybindings + two custom binds (Mod+Return for kitty, Mod+Space for walker). No deep customization — the goal is to try Niri and see if it sticks.

## Files

### New files

| File | Purpose |
|---|---|
| `home/dotfiles/niri/config.kdl` | Niri config — based on upstream default with minimal tweaks |
| `modules/home-manager/niri.nix` | Symlinks dotfiles, declares packages needed by Niri session |
| `modules/home-manager/noctalia.nix` | Enables Noctalia shell via flake homeModule |

### Modified files

| File | Change |
|---|---|
| `flake.nix` | Add `niri` and `noctalia` flake inputs |
| `modules/nixos/desktop.nix` | Add `programs.niri.enable = true` (NixOS module from niri-flake) |
| `home/maksim.nix` | Import `niri.nix` and `noctalia.nix` |

## Flake inputs

```nix
niri = {
  url = "github:sodiboo/niri-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};

noctalia = {
  url = "github:noctalia-dev/noctalia-shell";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## config.kdl

Based on niri upstream default config. Changes from default:

1. **Added binds**: `Mod+Return` spawns kitty, `Mod+Space` spawns walker
2. **Input**: touchpad tap + natural-scroll (already default), mouse natural-scroll added (matches current qtile config)
3. **Layout**: gaps 8 (instead of default 16), `prefer-no-csd` enabled, shadows enabled
4. **spawn-at-startup**: `xwayland-satellite` (XWayland support for X11 apps)
5. **Removed**: waybar from spawn-at-startup (replaced by Noctalia which auto-starts via systemd)
6. **screenshot-path**: kept default `~/Pictures/Screenshots/`

Everything else stays default — hjkl navigation, workspaces 1-9, volume/brightness keys, overview, etc.

## modules/home-manager/niri.nix

- Symlinks `home/dotfiles/niri/` to `~/.config/niri/` (same pattern as qtile.nix)
- Packages: `xwayland-satellite` (XWayland bridge for niri)

No custom systemd target needed — niri-flake's `programs.niri.enable` handles `graphical-session.target` automatically.

## modules/home-manager/noctalia.nix

- Uses `programs.noctalia-shell.enable = true` from flake homeModule
- Default config — includes workspace indicator, clock, system tray, battery, network, audio

## modules/nixos/desktop.nix

Add niri-flake NixOS module import and enable:

```nix
programs.niri.enable = true;
```

This registers a Niri session in SDDM alongside Qtile and Plasma.

## What stays unchanged

- Qtile config and module — untouched
- Shared services (dunst, gammastep, walker, kitty, etc.) — they depend on `graphical-session.target` which both Qtile and Niri activate
- SDDM, Plasma 6, XDG portals, PipeWire — all shared infrastructure remains
