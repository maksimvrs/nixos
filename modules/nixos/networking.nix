# modules/nixos/networking.nix
{ variables, pkgs, ... }: {
  networking.hostName = variables.hostname;
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
    wifi = {
      powersave = false;         # prevent WiFi from dropping on idle
      scanRandMacAddress = false; # MAC randomization can break some APs
    };
  };
}
