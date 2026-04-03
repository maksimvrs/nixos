# modules/nixos/sops.nix
{ ... }: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;

    age = {
      # Path to the age private key on the machine.
      # On fresh install: cp ~/.config/sops/age/keys.txt /mnt/var/lib/sops-nix/key.txt
      keyFile      = "/var/lib/sops-nix/key.txt";
      generateKey  = true;  # auto-generates a machine key if none exists
    };

    secrets = {
      jwi-ovpn = {
        owner = "root";
        mode  = "400";
      };
    };
  };
}
