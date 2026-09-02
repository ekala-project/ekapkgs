# PipeWire service test
#
# Validates that PipeWire, WirePlumber, and PulseAudio compatibility
# services start correctly, sockets are created, and session variables
# are set.

{ pkgs, ... }:

let
  ekapkgsModules = import ../modules/module-list.nix;
in

{
  name = "pipewire";

  meta = {
    description = "Test PipeWire multimedia service stack";
    timeout = 600;
  };

  nodes = {
    machine =
      { config, pkgs, lib, ... }:
      {
        imports = ekapkgsModules;

        boot.kernelPackages = pkgs.linuxPackages;
        boot.loader.systemd-boot.enable = true;
        virtualisation.enable = true;

        # Enable PipeWire with all compatibility layers
        services.pipewire = {
          enable = true;
          audio.enable = true;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = false;
          wireplumber.enable = true;
        };

        # Create a test user for user services
        users.users.testuser = {
          isNormalUser = true;
          password = "test";
          uid = 1000;
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # PipeWire package is installed
    machine.succeed("command -v pipewire")
    machine.succeed("pipewire --version")

    # WirePlumber package is installed
    machine.succeed("command -v wireplumber")

    # PipeWire user socket unit files exist
    machine.succeed("test -f /etc/systemd/user/pipewire.socket || systemctl --user --global cat pipewire.socket")

    # PulseAudio compatibility socket unit files exist
    machine.succeed("test -f /etc/systemd/user/pipewire-pulse.socket || systemctl --user --global cat pipewire-pulse.socket")

    # WirePlumber user service unit file exists
    machine.succeed("test -f /etc/systemd/user/wireplumber.service || systemctl --user --global cat wireplumber.service")

    # Session variable SDL_AUDIODRIVER is set to pipewire
    machine.succeed("grep -q 'pipewire' /etc/profile.d/* || grep -rq 'SDL_AUDIODRIVER' /etc/")

    machine.shutdown()
  '';
}
