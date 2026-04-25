# Niri + Noctalia Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Niri compositor + Noctalia desktop shell alongside existing Qtile, selectable from SDDM at login.

**Architecture:** Niri is added via sodiboo/niri-flake (NixOS module for session registration + overlay). Noctalia via its own flake homeModule. Niri config is a raw KDL dotfile symlinked by home-manager, following the same pattern as existing Qtile setup.

**Tech Stack:** NixOS, home-manager, niri-flake, noctalia-shell flake, KDL config format

---

### Task 1: Add flake inputs

**Files:**
- Modify: `flake.nix`

- [ ] **Step 1: Add niri and noctalia inputs**

Add two new inputs after `claude-code`:

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

Add `niri` and `noctalia` to the `outputs` function arguments (after `claude-code`):

```nix
outputs =
  {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    firefox-addons,
    claude-code,
    niri,
    noctalia,
    ...
  }:
```

- [ ] **Step 2: Add niri NixOS module to the modules list**

In the `modules` list inside `nixosConfigurations`, add the niri NixOS module. Place it after the claude-code overlay line:

```nix
modules = [
  { nixpkgs.overlays = [ claude-code.overlays.default ]; }

  niri.nixosModules.niri

  ./hosts/thinkpad-x1/default.nix
  ./hosts/thinkpad-x1/hardware-configuration.nix
  ...
```

- [ ] **Step 3: Add noctalia homeModule to sharedModules**

In the `home-manager` config block, add the noctalia homeModule to `sharedModules`:

```nix
sharedModules = [
  zen-browser.homeModules.beta
  noctalia.homeModules.default
];
```

- [ ] **Step 4: Run `nix flake lock --update-input niri --update-input noctalia` to fetch the new inputs**

Run:
```bash
nix flake lock --update-input niri --update-input noctalia
```

Expected: `flake.lock` updated with niri and noctalia entries. No errors.

- [ ] **Step 5: Commit**

```bash
git add flake.nix flake.lock
git commit -m "feat: add niri-flake and noctalia flake inputs"
```

---

### Task 2: Enable Niri in NixOS desktop module

**Files:**
- Modify: `modules/nixos/desktop.nix`

- [ ] **Step 1: Add programs.niri.enable**

In `modules/nixos/desktop.nix`, add `niri.enable = true` inside the existing `programs` block (after `ssh.startAgent`):

```nix
programs = {
  xwayland.enable = true;
  ssh.startAgent = false;
  niri.enable = true;
};
```

This registers a Niri Wayland session in SDDM alongside Qtile and Plasma. The niri-flake NixOS module (imported in flake.nix) provides this option.

- [ ] **Step 2: Commit**

```bash
git add modules/nixos/desktop.nix
git commit -m "feat: enable niri wayland session in SDDM"
```

---

### Task 3: Create Niri KDL config

**Files:**
- Create: `home/dotfiles/niri/config.kdl`

- [ ] **Step 1: Create the dotfiles directory**

```bash
mkdir -p home/dotfiles/niri
```

- [ ] **Step 2: Write config.kdl**

Create `home/dotfiles/niri/config.kdl` based on niri upstream default with these changes from default:
1. Added `Mod+Return` → kitty, `Mod+Space` → walker
2. Mouse natural-scroll enabled (matching existing qtile setup)
3. Layout gaps reduced from 16 to 8
4. `prefer-no-csd` enabled
5. Shadows enabled
6. Removed `spawn-at-startup "waybar"` (Noctalia replaces it)
7. Added `spawn-at-startup "xwayland-satellite"` for X11 app support
8. Keyboard xkb: `layout "us,ru"` and `options "grp:alt_shift_toggle"` (matching `modules/nixos/keyboard.nix`)

Full file content:

```kdl
// Niri config — based on upstream default with minimal tweaks.
// See: https://niri-wm.github.io/niri/Configuration:-Introduction

input {
    keyboard {
        xkb {
            layout "us,ru"
            options "grp:alt_shift_toggle"
        }
        numlock
    }

    touchpad {
        tap
        natural-scroll
    }

    mouse {
        natural-scroll
    }
}

layout {
    gaps 8

    center-focused-column "never"

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }

    default-column-width { proportion 0.5; }

    focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
    }

    border {
        off
        width 4
        active-color "#ffc87f"
        inactive-color "#505050"
        urgent-color "#9b0000"
    }

    shadow {
        on
        softness 30
        spread 5
        offset x=0 y=5
        color "#0007"
    }
}

prefer-no-csd

spawn-at-startup "xwayland-satellite"

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

hotkey-overlay {
    // skip-at-startup
}

animations {}

// Work around WezTerm's initial configure bug.
window-rule {
    match app-id=r#"^org\.wezfurlong\.wezterm$"#
    default-column-width {}
}

// Firefox picture-in-picture as floating.
window-rule {
    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    open-floating true
}

binds {
    // ── Help ────────────────────────────────────────────────────────────
    Mod+Shift+Slash { show-hotkey-overlay; }

    // ── Launch ──────────────────────────────────────────────────────────
    Mod+Return hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }
    Mod+T      hotkey-overlay-title="Open a Terminal: kitty" { spawn "kitty"; }
    Mod+Space  hotkey-overlay-title="App Launcher: walker"   { spawn "walker"; }
    Mod+D      hotkey-overlay-title="App Launcher: walker"   { spawn "walker"; }

    // ── Lock screen ─────────────────────────────────────────────────────
    Super+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "gtklock"; }

    // ── Volume (PipeWire + WirePlumber) ─────────────────────────────────
    XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
    XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
    XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

    // ── Brightness ──────────────────────────────────────────────────────
    XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
    XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

    // ── Overview ────────────────────────────────────────────────────────
    Mod+O repeat=false { toggle-overview; }

    // ── Window management ───────────────────────────────────────────────
    Mod+Q repeat=false { close-window; }

    // Focus (hjkl + arrows)
    Mod+Left  { focus-column-left; }
    Mod+Down  { focus-window-down; }
    Mod+Up    { focus-window-up; }
    Mod+Right { focus-column-right; }
    Mod+H     { focus-column-left; }
    Mod+J     { focus-window-down; }
    Mod+K     { focus-window-up; }
    Mod+L     { focus-column-right; }

    // Move windows (Ctrl + hjkl/arrows)
    Mod+Ctrl+Left  { move-column-left; }
    Mod+Ctrl+Down  { move-window-down; }
    Mod+Ctrl+Up    { move-window-up; }
    Mod+Ctrl+Right { move-column-right; }
    Mod+Ctrl+H     { move-column-left; }
    Mod+Ctrl+J     { move-window-down; }
    Mod+Ctrl+K     { move-window-up; }
    Mod+Ctrl+L     { move-column-right; }

    Mod+Home      { focus-column-first; }
    Mod+End       { focus-column-last; }
    Mod+Ctrl+Home { move-column-to-first; }
    Mod+Ctrl+End  { move-column-to-last; }

    // Focus monitor (Shift + hjkl/arrows)
    Mod+Shift+Left  { focus-monitor-left; }
    Mod+Shift+Down  { focus-monitor-down; }
    Mod+Shift+Up    { focus-monitor-up; }
    Mod+Shift+Right { focus-monitor-right; }
    Mod+Shift+H     { focus-monitor-left; }
    Mod+Shift+J     { focus-monitor-down; }
    Mod+Shift+K     { focus-monitor-up; }
    Mod+Shift+L     { focus-monitor-right; }

    // Move to monitor (Shift+Ctrl + hjkl/arrows)
    Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
    Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
    Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
    Mod+Shift+Ctrl+H     { move-column-to-monitor-left; }
    Mod+Shift+Ctrl+J     { move-column-to-monitor-down; }
    Mod+Shift+Ctrl+K     { move-column-to-monitor-up; }
    Mod+Shift+Ctrl+L     { move-column-to-monitor-right; }

    // ── Workspaces ──────────────────────────────────────────────────────
    Mod+Page_Down      { focus-workspace-down; }
    Mod+Page_Up        { focus-workspace-up; }
    Mod+U              { focus-workspace-down; }
    Mod+I              { focus-workspace-up; }
    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
    Mod+Ctrl+U         { move-column-to-workspace-down; }
    Mod+Ctrl+I         { move-column-to-workspace-up; }

    Mod+Shift+Page_Down { move-workspace-down; }
    Mod+Shift+Page_Up   { move-workspace-up; }
    Mod+Shift+U         { move-workspace-down; }
    Mod+Shift+I         { move-workspace-up; }

    // Numbered workspaces
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }
    Mod+6 { focus-workspace 6; }
    Mod+7 { focus-workspace 7; }
    Mod+8 { focus-workspace 8; }
    Mod+9 { focus-workspace 9; }
    Mod+Ctrl+1 { move-column-to-workspace 1; }
    Mod+Ctrl+2 { move-column-to-workspace 2; }
    Mod+Ctrl+3 { move-column-to-workspace 3; }
    Mod+Ctrl+4 { move-column-to-workspace 4; }
    Mod+Ctrl+5 { move-column-to-workspace 5; }
    Mod+Ctrl+6 { move-column-to-workspace 6; }
    Mod+Ctrl+7 { move-column-to-workspace 7; }
    Mod+Ctrl+8 { move-column-to-workspace 8; }
    Mod+Ctrl+9 { move-column-to-workspace 9; }

    // ── Column / window layout ──────────────────────────────────────────
    Mod+BracketLeft  { consume-or-expel-window-left; }
    Mod+BracketRight { consume-or-expel-window-right; }
    Mod+Comma        { consume-window-into-column; }
    Mod+Period       { expel-window-from-column; }

    Mod+R       { switch-preset-column-width; }
    Mod+Shift+R { switch-preset-column-width-back; }
    Mod+Ctrl+Shift+R { switch-preset-window-height; }
    Mod+Ctrl+R  { reset-window-height; }

    Mod+F       { maximize-column; }
    Mod+Shift+F { fullscreen-window; }
    Mod+M       { maximize-window-to-edges; }
    Mod+Ctrl+F  { expand-column-to-available-width; }
    Mod+C       { center-column; }
    Mod+Ctrl+C  { center-visible-columns; }

    // Resize
    Mod+Minus { set-column-width "-10%"; }
    Mod+Equal { set-column-width "+10%"; }
    Mod+Shift+Minus { set-window-height "-10%"; }
    Mod+Shift+Equal { set-window-height "+10%"; }

    // Floating
    Mod+V       { toggle-window-floating; }
    Mod+Shift+V { switch-focus-between-floating-and-tiling; }

    // Tabbed columns
    Mod+W { toggle-column-tabbed-display; }

    // ── Mouse wheel ─────────────────────────────────────────────────────
    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

    Mod+WheelScrollRight      { focus-column-right; }
    Mod+WheelScrollLeft       { focus-column-left; }
    Mod+Ctrl+WheelScrollRight { move-column-right; }
    Mod+Ctrl+WheelScrollLeft  { move-column-left; }

    Mod+Shift+WheelScrollDown      { focus-column-right; }
    Mod+Shift+WheelScrollUp        { focus-column-left; }
    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

    // ── Screenshots ─────────────────────────────────────────────────────
    Print      { screenshot; }
    Ctrl+Print { screenshot-screen; }
    Alt+Print  { screenshot-window; }

    // ── Session ─────────────────────────────────────────────────────────
    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    Mod+Shift+E { quit; }
    Ctrl+Alt+Delete { quit; }
    Mod+Shift+P { power-off-monitors; }
}
```

- [ ] **Step 3: Commit**

```bash
git add home/dotfiles/niri/config.kdl
git commit -m "feat: add niri KDL config with default bindings + kitty/walker"
```

---

### Task 4: Create niri home-manager module

**Files:**
- Create: `modules/home-manager/niri.nix`

- [ ] **Step 1: Write niri.nix**

Create `modules/home-manager/niri.nix` following the same pattern as `modules/home-manager/qtile.nix`:

```nix
# modules/home-manager/niri.nix
#
# Manages niri dotfiles and user-level dependencies.
# The actual niri config lives in home/dotfiles/niri/ — this module
# symlinks everything from that directory into ~/.config/niri/.
{ pkgs, ... }:
{
  xdg.configFile."niri" = {
    source = ../../home/dotfiles/niri;
    recursive = true;
  };

  home.packages = with pkgs; [
    xwayland-satellite # XWayland support for niri
  ];
}
```

- [ ] **Step 2: Commit**

```bash
git add modules/home-manager/niri.nix
git commit -m "feat: add niri home-manager module (dotfile symlink + packages)"
```

---

### Task 5: Create noctalia home-manager module

**Files:**
- Create: `modules/home-manager/noctalia.nix`

- [ ] **Step 1: Write noctalia.nix**

Create `modules/home-manager/noctalia.nix`:

```nix
# modules/home-manager/noctalia.nix
#
# Noctalia desktop shell — bar, notifications, widgets.
# Enabled via the noctalia flake homeModule (added to sharedModules in flake.nix).
_: {
  programs.noctalia-shell.enable = true;
}
```

- [ ] **Step 2: Commit**

```bash
git add modules/home-manager/noctalia.nix
git commit -m "feat: add noctalia home-manager module"
```

---

### Task 6: Wire modules into home config

**Files:**
- Modify: `home/maksim.nix`

- [ ] **Step 1: Add niri and noctalia imports**

Add two new imports to `home/maksim.nix`, after the `qtile.nix` line:

```nix
imports = [
    ../modules/home-manager/packages.nix
    ../modules/home-manager/neovim.nix
    ../modules/home-manager/shell.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/ssh.nix
    ../modules/home-manager/kitty.nix
    ../modules/home-manager/cursor.nix
    ../modules/home-manager/zen-browser.nix
    ../modules/home-manager/claude.nix
    ../modules/home-manager/dunst.nix
    ../modules/home-manager/gammastep.nix
    ../modules/home-manager/walker.nix
    ../modules/home-manager/qtile.nix
    ../modules/home-manager/niri.nix
    ../modules/home-manager/noctalia.nix
    ../modules/home-manager/xdg.nix
    ../modules/home-manager/opencode.nix
    ../modules/home-manager/obs.nix
  ];
```

- [ ] **Step 2: Commit**

```bash
git add home/maksim.nix
git commit -m "feat: import niri and noctalia modules in home config"
```

---

### Task 7: Build and verify

- [ ] **Step 1: Dry-build the NixOS configuration**

```bash
sudo nixos-rebuild dry-build --flake .
```

Expected: build succeeds with no errors. This validates that all modules resolve, niri session is registered, and noctalia is available.

- [ ] **Step 2: Commit any lockfile changes if not already committed**

```bash
git add flake.lock
git commit -m "chore: update flake.lock with niri and noctalia"
```

(Skip if flake.lock was already committed in Task 1.)

- [ ] **Step 3: Apply the configuration**

```bash
sudo nixos-rebuild switch --flake .
```

Expected: system rebuilds. SDDM now shows Niri as a session option alongside Qtile and Plasma.

- [ ] **Step 4: Test — log into Niri from SDDM**

1. Log out of current session
2. In SDDM, select "Niri" session
3. Log in
4. Verify: Noctalia bar appears at top, Mod+Return opens kitty, Mod+Space opens walker, hjkl navigation works, workspaces 1-9 work
