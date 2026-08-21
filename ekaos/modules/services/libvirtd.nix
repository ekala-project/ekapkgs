# Libvirt virtualization daemon
# Provides VM management via QEMU/KVM, LXC, etc.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.virtualisation.libvirtd;

  hasQemu = pkgs ? qemu;

in

{
  options = {
    virtualisation.libvirtd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the libvirt virtualization daemon.

          libvirtd provides management of virtual machines, networks,
          and storage through QEMU/KVM, LXC, and other hypervisors.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.libvirt;
        description = "Libvirt package to use.";
      };

      qemuPackage = mkOption {
        type = types.nullOr types.package;
        default = if hasQemu then pkgs.qemu else null;
        description = "QEMU package to use for KVM virtual machines.";
      };

      allowedBridges = mkOption {
        type = types.listOf types.str;
        default = [ "virbr0" ];
        description = "List of bridge interfaces QEMU is allowed to use.";
      };

      onBoot = mkOption {
        type = types.enum [ "start" "ignore" ];
        default = "start";
        description = "Action to take on VMs when the host boots.";
      };

      onShutdown = mkOption {
        type = types.enum [ "shutdown" "suspend" ];
        default = "suspend";
        description = "Action to take on VMs when the host shuts down.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Create libvirtd group
    users.groups.libvirtd = { };

    # Add libvirt and optionally qemu to system packages
    environment.systemPackages = [ cfg.package ]
      ++ optional (cfg.qemuPackage != null) cfg.qemuPackage;

    # Load KVM kernel modules
    boot.kernelModules = [ "kvm" "kvm_intel" "kvm_amd" ];

    # Create required directories
    system.activationScripts.libvirtd = stringAfter [ "etc" "users" ] ''
      mkdir -p /var/lib/libvirt /var/lib/libvirt/images /var/lib/libvirt/qemu
      mkdir -p /var/lib/libvirt/network /var/log/libvirt /var/log/libvirt/qemu
      mkdir -p /run/libvirt
      chmod 755 /var/lib/libvirt
      chmod 711 /var/lib/libvirt/images
      chmod 750 /var/log/libvirt
      chmod 755 /run/libvirt
    '';

    # Write qemu bridge helper ACL
    environment.etc."qemu/bridge.conf" = mkIf (cfg.allowedBridges != [ ]) {
      text = concatMapStringsSep "\n" (br: "allow ${br}") cfg.allowedBridges + "\n";
      mode = "0644";
    };
  };
}
