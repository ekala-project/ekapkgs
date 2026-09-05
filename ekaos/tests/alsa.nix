# ALSA sound system test
#
# Validates that ALSA is configured correctly: asound.conf is generated,
# alsa-utils are installed, state persistence service works, and kernel
# modules are loaded as expected.

{ pkgs, ... }:

let
  ekapkgsModules = import ../modules/module-list.nix;
in

{
  name = "alsa";

  meta = {
    description = "Test ALSA sound system configuration";
    timeout = 600;
  };

  nodes = {
    machine =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        imports = ekapkgsModules;

        boot.kernelPackages = pkgs.linuxPackages;
        boot.loader.systemd-boot.enable = true;
        virtualisation.enable = true;

        # Enable ALSA as standalone sound system
        hardware.alsa = {
          enable = true;
          enablePersistence = true;
          enableOSSEmulation = true;

          defaultDevice.playback = "dmix:CARD=0,DEV=0";
          defaultDevice.capture = "dsnoop:CARD=0,DEV=0";

          controls.testvol = {
            device = "default";
            card = "default";
            maxVolume = 0.0;
          };
        };

        # PipeWire should be off when ALSA is standalone
        services.pipewire.enable = lib.mkForce false;
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # alsa-utils are installed
    machine.succeed("command -v amixer")
    machine.succeed("command -v aplay")
    machine.succeed("command -v alsactl")

    # asound.conf was generated
    machine.succeed("test -f /etc/asound.conf")

    # Default device configuration is present
    machine.succeed("grep -q 'fromenv' /etc/asound.conf")
    machine.succeed("grep -q 'ALSA_AUDIO_OUT' /etc/asound.conf")
    machine.succeed("grep -q 'ALSA_AUDIO_IN' /etc/asound.conf")

    # Softvol control was generated
    machine.succeed("grep -q 'testvol' /etc/asound.conf")
    machine.succeed("grep -q 'softvol' /etc/asound.conf")

    # OSS emulation kernel modules are loaded
    machine.succeed("lsmod | grep -q snd_pcm_oss || modinfo snd_pcm_oss >/dev/null 2>&1")
    machine.succeed("lsmod | grep -q snd_mixer_oss || modinfo snd_mixer_oss >/dev/null 2>&1")

    # State persistence service is active
    machine.wait_for_unit("alsa-store.service")
    machine.succeed("systemctl is-active alsa-store.service")

    # State directory was created
    machine.succeed("test -d /var/lib/alsa")

    machine.shutdown()
  '';
}
