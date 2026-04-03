# modules/nixos/networking.nix
{ variables, ... }: {
  networking.hostName = variables.hostname;
  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = false;         # prevent WiFi from dropping on idle
      scanRandMacAddress = false; # MAC randomization can break some APs
    };
  };
}
