# modules/nixos/vpn.nix
{ config, pkgs, ... }: {
  services.openvpn.servers.zeustrack = {
    config           = "config ${config.age.secrets.jwi-ovpn.path}";
    autoStart        = false;
    updateResolvConf = true;
  };

  environment.systemPackages = [ pkgs.networkmanager-openvpn ];
}
