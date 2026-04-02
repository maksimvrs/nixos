# NixOS Config Design

**Date:** 2026-04-02  
**Host:** maksim-pc  
**User:** maksim

---

## Overview

A clean, modular NixOS configuration using flakes and home-manager. Starts minimal but structured to grow — adding hosts, modules, or features requires no restructuring.

---

## File Structure

```
nixos-config/
├── flake.nix
├── flake.lock
├── hosts/
│   └── maksim-pc/
│       ├── default.nix               # imports all nixos modules, wires home-manager
│       ├── hardware-configuration.nix # placeholder — generate with nixos-generate-config
│       └── variables.nix             # host-specific values
├── modules/
│   ├── nixos/
│   │   ├── boot.nix
│   │   ├── networking.nix
│   │   ├── locale.nix
│   │   ├── users.nix
│   │   ├── fonts.nix
│   │   └── desktop.nix
│   └── home-manager/
│       ├── shell.nix
│       └── git.nix
└── home/
    └── maksim.nix
```

---

## Data Flow

```
flake.nix
  └─ specialArgs: { variables }
      └─ hosts/maksim-pc/default.nix
          ├─ modules/nixos/{boot,networking,locale,users,fonts,desktop}.nix
          └─ home-manager → home/maksim.nix
              └─ modules/home-manager/{shell,git}.nix
```

`variables` is passed via `specialArgs` (NixOS) and `extraSpecialArgs` (home-manager) so no module hardcodes host-specific values.

---

## Flake Inputs

| Input | URL | Purpose |
|-------|-----|---------|
| `nixpkgs` | `github:nixos/nixpkgs/nixos-unstable` | Main package set |
| `home-manager` | `github:nix-community/home-manager` | User environment management |
| `zen-browser` | `github:0xc000022070/zen-browser-flake` | Zen browser (not in nixpkgs) |

`home-manager.inputs.nixpkgs.follows = "nixpkgs"` to avoid duplicate nixpkgs.  
`zen-browser.inputs.nixpkgs.follows = "nixpkgs"` same.

---

## hosts/maksim-pc/variables.nix

```nix
{
  username = "maksim";
  hostname = "maksim-pc";
  timezone = "Asia/Almaty";
  gitName = "Maksim Vorontsov";
  gitEmail = "maksim.vorontsov@zemomedia.com";
  stateVersion = "25.05";
}
```

---

## NixOS Modules

### boot.nix
- `systemd-boot` bootloader, EFI support
- `nix.settings.experimental-features = ["nix-command" "flakes"]`
- `nix.gc` — weekly GC, delete older than 30 days
- `nixpkgs.config.allowUnfree = true`

### networking.nix
- `networking.hostName` from variables
- `networking.networkmanager.enable = true`

### locale.nix
- `time.timeZone` from variables
- `i18n.defaultLocale = "en_US.UTF-8"`
- Extra LC_ settings in `en_GB.UTF-8`

### users.nix
- User from variables: `isNormalUser`, groups `[wheel networkmanager audio video docker]`
- Shell: `pkgs.zsh`
- `programs.zsh.enable = true` (required for system-level zsh)

### fonts.nix
- `nerd-fonts.fira-code`
- `nerd-fonts.jetbrains-mono`
- `noto-fonts`, `noto-fonts-color-emoji`
- `font-awesome`

### desktop.nix
- `services.desktopManager.plasma6.enable = true`
- `services.displayManager.sddm.enable = true` with Wayland
- PipeWire: `services.pipewire.enable`, alsa, pulse, wireplumber
- `security.rtkit.enable = true`
- Bluetooth: `hardware.bluetooth.enable = true`, `services.blueman.enable = true`
- `xdg.portal.enable = true`

---

## Home-Manager Modules

### shell.nix
- zsh with oh-my-zsh
  - Plugins: `git`, `docker`, `fzf`
  - Theme: `robbyrussell`
- Starship prompt
- `programs.direnv` with nix-direnv
- Session variables: `EDITOR=nvim`, `VISUAL=nvim`, `TERM=kitty`, `BROWSER=zen`
- Aliases: `nix-switch = "sudo nixos-rebuild switch --flake .#maksim-pc"`

### git.nix
- `userName` and `userEmail` from variables

---

## home/maksim.nix

Home-manager root. Imports `modules/home-manager/{shell,git}.nix`.

Packages:
- **Terminal:** `kitty`
- **Browser:** `zen-browser` (from flake)
- **Editors:** `neovim`
- **CLI essentials:** `btop`, `fzf`, `bat`, `eza`, `lazygit`, `jq`, `tldr`, `ripgrep`, `fd`
- **Archives:** `zip`, `unzip`
- **Misc:** `wget`, `curl`

`programs.home-manager.enable = true`

---

## What's Intentionally Excluded from Minimal Config

The following exist in the old config but are not included here — add as separate modules when needed:
- VPN (mullvad, openvpn, mihomo)
- Virtualization (docker, virtualbox)
- Fingerprint reader
- OBS / v4l2loopback
- MPD / audio tools
- Development language toolchains
- Communication apps (telegram, slack, discord)
