# GNOME graphical installation/live CD for EkaOS
#
# Produces a bootable ISO with the full GNOME desktop, suitable for
# both trying EkaOS and installing it.
#
# Build with:
#   nix build .#iso-gnome
#
# Test with:
#   qemu-system-x86_64 -bios /path/to/OVMF.fd -cdrom result/iso/*.iso -m 4G
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
  isoImage.edition = "gnome";
  isoImage.volumeID = "EKAOS_GNOME";
  isoImage.bootMenuLabel = "EkaOS ${config.system.ekaos.version} (GNOME)";

  # GNOME desktop environment
  services.desktopManager.gnome.enable = true;

  # GDM display manager with auto-login for the live session
  services.xserver.displayManager.gdm = {
    enable = true;
    # Prevent auto-suspend which causes issues for SSH and unattended use
    autoSuspend = false;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  # Audio
  services.pipewire.enable = true;

  # Plymouth boot splash
  boot.plymouth.enable = true;

  # Boot to graphical target
  systemd.defaultTarget = "graphical.target";

  # Additional packages for the graphical live environment
  environment.systemPackages = with pkgs; [
    gparted
    vim
    mesa-demos
  ];
}
