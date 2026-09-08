# Plasma 6 (Qt6) graphical installation/live CD for EkaOS
#
# NOT YET FUNCTIONAL — blocked on missing KDE packages.
# See ekaos/modules/services/plasma6.nix for details.
#
# When KDE packages become available, this configuration will produce
# a bootable ISO with the Plasma 6 desktop, SDDM display manager,
# and core KDE applications.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    # Base live CD from corepkgs
    (modulesPath + "/installer/installation-cd-base.nix")
  ];

  # ISO identity
  isoImage.edition = "plasma6";
  isoImage.volumeID = "EKAOS_PLASMA6";
  isoImage.bootMenuLabel = "EkaOS ${config.system.ekaos.version} (Plasma 6)";

  # Plasma 6 desktop environment (currently blocked — see plasma6.nix)
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = false; # Pure Qt6 for the ISO
  };

  # SDDM display manager
  # services.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  # Audio
  services.pipewire.enable = true;

  # Plymouth boot splash
  boot.plymouth.enable = true;

  # Boot to graphical target
  systemd.defaultTarget = "graphical.target";
}
