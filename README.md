# nixos-config

Personal NixOS flake configuration.

## Structure

```
.
├── flake.nix
├── hosts/
│   └── <hostname>/
│       ├── default.nix              # imports all nixos modules
│       ├── variables.nix            # username, timezone, git settings, etc.
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/                       # system-level config (one file per concern)
│   └── home-manager/                # user-level config (one file per app/concern)
├── home/
│   └── <username>.nix               # home-manager entry point
└── secrets/
    └── secrets.yaml                 # sops-encrypted (password, VPN, etc.)
```

## Fresh Install

```bash
# 1. Boot NixOS installer, mount partitions to /mnt

# 2. Restore your age key from Bitwarden — paste the contents into:
mkdir -p /mnt/var/lib/sops-nix
nano /mnt/var/lib/sops-nix/key.txt
# Expected format:
#   # created: ...
#   # public key: age1...
#   AGE-SECRET-KEY-1...

# 3. Generate and copy hardware config
nixos-generate-config --root /mnt --dir /mnt/etc/nixos
cp /mnt/etc/nixos/hardware-configuration.nix hosts/<hostname>/

# 4. Install
nixos-install --flake .#<hostname>
```

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Editing secrets

```bash
nix shell nixpkgs#sops --command sops secrets/secrets.yaml
```
