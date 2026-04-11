# hosts/thinkpad-x1/audio-quirks.nix
#
# Hardware-specific audio workarounds for ThinkPad X1 Carbon Gen 11
# (Intel SOF + Realtek ALC287, HDA:10ec0287,17aa2315).
#
# Symptom: every few seconds the headphone jack detector fires a
# phantom plug/unplug event even with nothing connected to the 3.5 mm
# jack. This caused two separate audible problems:
#
#   1. WirePlumber tore down and recreated every sink on the card
#      whenever ACP card-profile availability flipped between the
#      "Headphones" and "Speaker" HiFi profiles. Active streams lost
#      their output device, and browsers paused media on
#      "output device changed" (HTMLMediaElement default behaviour).
#
#   2. The snd_hda_codec_realtek driver performs its own hardware
#      auto-mute on jack events, briefly silencing the Speaker output
#      even while the PipeWire graph itself stayed intact.
#
# Fix:
#
#   * WirePlumber monitor rule pins the card to the Speaker profile
#     and disables ACP auto-profile/auto-port switching.
#   * A oneshot systemd service disables the driver's Auto-Mute Mode
#     mixer control at boot (ALSA mixer state is not persisted by
#     default under PipeWire).
#
# Tradeoff: wired headphones on the 3.5 mm jack will no longer be
# selected automatically — the profile would have to be switched
# manually (e.g. `wpctl set-profile ...`) and Auto-Mute re-enabled.
# Bluetooth audio is a separate card and is unaffected.

{ pkgs, ... }:
{
  environment.etc."wireplumber/wireplumber.conf.d/51-alc287-lock-profile.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic"
          }
        ]
        actions = {
          update-props = {
            api.acp.auto-profile = false
            api.acp.auto-port    = false
            device.profile       = "HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"
          }
        }
      }
    ]
  '';

  systemd.services.alc287-disable-auto-mute = {
    description = "Disable ALC287 HDA Auto-Mute (ThinkPad X1 Carbon Gen 11)";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    # The control may not exist immediately after boot if the HDA card
    # is still probing, so retry for a few seconds before giving up.
    script = ''
      for _ in $(seq 1 10); do
        if ${pkgs.alsa-utils}/bin/amixer -c 0 sset 'Auto-Mute Mode' Disabled > /dev/null 2>&1; then
          exit 0
        fi
        sleep 1
      done
      exit 1
    '';
  };
}
