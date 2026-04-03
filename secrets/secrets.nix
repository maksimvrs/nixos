# secrets/secrets.nix
# Declares which age/SSH public keys can decrypt which secrets.
#
# HOW TO FILL IN KEYS:
#   User key:  cat ~/.ssh/id_ed25519.pub   (or id_rsa.pub)
#   Host key:  cat /etc/ssh/ssh_host_ed25519_key.pub
#              (generated on first boot, or: ssh-keygen -A)
#
# HOW TO ENCRYPT SECRETS:
#   Password:  mkpasswd -m sha-512 | agenix -e secrets/maksim-password.age
#   VPN:       agenix -e secrets/jwi.ovpn.age  (paste content, save & exit)
#
# Run from repo root: nix run github:ryantm/agenix -- -e secrets/<file>.age
let
  # Public SSH keys allowed to encrypt/decrypt secrets
  maksim     = "ssh-ed25519 AAAA...  # TODO: replace with ~/.ssh/id_ed25519.pub";
  thinkpad   = "ssh-ed25519 AAAA...  # TODO: replace with /etc/ssh/ssh_host_ed25519_key.pub";

  users   = [ maksim ];
  systems = [ thinkpad ];
in {
  "secrets/jwi.ovpn.age".publicKeys      = users ++ systems;
  "secrets/maksim-password.age".publicKeys = users ++ systems;
}
