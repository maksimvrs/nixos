# modules/home-manager/obs.nix
{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs # wlroots screen capture
      obs-pipewire-audio-capture # PipeWire audio capture
    ];
  };
}
