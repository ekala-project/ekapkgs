# GVfs — userspace virtual filesystem for GNOME
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gvfs;
in

{
  options.services.gvfs = {
    enable = mkEnableOption "GVfs, a userspace virtual filesystem";

    package = mkOption {
      type = types.package;
      default = pkgs.gvfs;
      description = "GVfs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    # TODO: services.udev.packages = [ pkgs.libmtp.out ];
    # TODO: services.udisks2.enable = true;
    # TODO: programs.fuse.enable = true;

    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${cfg.package}/lib/gio/modules" ];
  };
}
