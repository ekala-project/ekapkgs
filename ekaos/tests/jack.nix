# JACK Audio Connection Kit test
#
# Validates that JACK is configured correctly: the jackaudio user/group
# exist, PAM realtime limits are set, the ALSA PCM plugin config is
# written, and the systemd service units are present.

{ pkgs, ... }:

let
  ekapkgsModules = import ../modules/module-list.nix;
in

{
  name = "jack";

  meta = {
    description = "Test JACK Audio Connection Kit service";
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

        # Enable JACK with ALSA PCM plugin (not loopback)
        services.jack = {
          jackd.enable = true;
          alsa.enable = true;
          loopback.enable = false;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # JACK package is installed
    machine.succeed("command -v jackd")

    # jackaudio user and group exist
    machine.succeed("id jackaudio")
    machine.succeed("getent group jackaudio")

    # jackaudio user is in the audio group
    machine.succeed("id -nG jackaudio | grep -q audio")

    # PAM realtime limits are configured for @jackaudio
    machine.succeed("grep -q '@jackaudio.*rtprio.*99' /etc/security/limits.conf || grep -rq '@jackaudio.*rtprio' /etc/security/limits.d/")
    machine.succeed("grep -q '@jackaudio.*memlock.*unlimited' /etc/security/limits.conf || grep -rq '@jackaudio.*memlock' /etc/security/limits.d/")

    # ALSA JACK PCM plugin config is present
    machine.succeed("test -f /etc/alsa/conf.d/98-jack.conf")
    machine.succeed("grep -q 'pcm_type.jack' /etc/alsa/conf.d/98-jack.conf")
    machine.succeed("grep -q 'libasound_module_pcm_jack' /etc/alsa/conf.d/98-jack.conf")

    # ALSA base JACK config is linked
    machine.succeed("test -f /etc/alsa/conf.d/50-jack.conf")

    # JACK_PROMISCUOUS_SERVER is set
    machine.succeed("grep -rq 'JACK_PROMISCUOUS_SERVER' /etc/")

    # Systemd service unit file exists
    machine.succeed("test -f /etc/systemd/system/jack.service || systemctl cat jack.service")

    # Systemd session unit file exists
    machine.succeed("test -f /etc/systemd/system/jack-session.service || systemctl cat jack-session.service")

    # udev rule for sound card hotplug is present
    machine.succeed("grep -rq 'SYSTEMD_WANTS.*jack.service' /etc/udev/rules.d/")

    machine.shutdown()
  '';
}
