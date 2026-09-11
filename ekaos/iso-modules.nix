# Curated list of ekapkgs modules for ISO image builds.
#
# The full module-list.nix references auto-generated program modules
# that may not all be present. This file lists only the service and
# config modules actually needed for graphical ISO images.
[
  # Desktop environments
  ./modules/services/gnome.nix
  ./modules/services/plasma6.nix

  # Display managers
  ./modules/services/gdm.nix
  ./modules/services/sddm.nix
  ./modules/services/lightdm.nix

  # X server
  ./modules/services/xserver.nix

  # Audio
  ./modules/services/pipewire.nix
  ./modules/services/alsa.nix
  ./modules/services/jack.nix

  # GNOME services
  ./modules/services/gnome-settings-daemon.nix
  ./modules/services/gnome-keyring.nix
  ./modules/services/gnome-online-accounts.nix
  ./modules/services/gnome-remote-desktop.nix
  ./modules/services/gnome-user-share.nix
  ./modules/services/gnome-browser-connector.nix
  ./modules/services/gnome-initial-setup.nix
  ./modules/services/gnome-software.nix

  # Desktop infrastructure
  ./modules/services/accounts-daemon.nix
  ./modules/services/at-spi2-core.nix
  ./modules/services/colord.nix
  ./modules/services/evolution-data-server.nix
  ./modules/services/gcr-ssh-agent.nix
  ./modules/services/glib-networking.nix
  ./modules/services/gvfs.nix
  ./modules/services/localsearch.nix
  ./modules/services/sushi.nix
  ./modules/services/tinysparql.nix
]
