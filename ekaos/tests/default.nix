# ekapkgs ekaos test suite
#
# Usage:
#   nix-build ekaos/tests -A pipewire
#   nix-build ekaos/tests -A alsa
#   nix-build ekaos/tests -A jack

{
  pkgs ? import ../../. { },
}:

{
  # PipeWire multimedia service test
  pipewire = pkgs.ekaosTest ./pipewire.nix;

  # ALSA sound system test
  alsa = pkgs.ekaosTest ./alsa.nix;

  # JACK Audio Connection Kit test
  jack = pkgs.ekaosTest ./jack.nix;
}
