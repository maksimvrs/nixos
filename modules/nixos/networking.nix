# modules/nixos/networking.nix
{ variables, pkgs, ... }:
{
  networking = {
    hostName = variables.hostname;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [ pkgs.networkmanager-openvpn ];
      wifi = {
        powersave = false; # prevent WiFi from dropping on idle
        scanRandMacAddress = false; # MAC randomization can break some APs
      };
    };
  };
  environment.systemPackages = [ pkgs.openvpn ];
  services.resolved = {
    enable = true;
    settings.Resolve.DNSStubListenerExtra = "172.17.0.1";
  };
}
