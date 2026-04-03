# modules/nixos/secrets.nix
{ ... }: {
  age.secrets = {
    maksim-password = {
      file = ../../secrets/maksim-password.age;
    };
    jwi-ovpn = {
      file  = ../../secrets/jwi.ovpn.age;
      owner = "root";
      mode  = "400";
    };
  };
}
