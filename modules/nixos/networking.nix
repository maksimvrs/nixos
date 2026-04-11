# modules/nixos/networking.nix
{ variables, pkgs, ... }:
{
  networking.hostName = variables.hostname;
  environment.systemPackages = [ pkgs.openvpn ];
  services.resolved.enable = true;
  services.resolved.settings.Resolve.DNSStubListenerExtra = "172.17.0.1";
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager = {
    enable = true;
    plugins = [ pkgs.networkmanager-openvpn ];
    wifi = {
      powersave = false; # prevent WiFi from dropping on idle
      scanRandMacAddress = false; # MAC randomization can break some APs
    };
  };
}
