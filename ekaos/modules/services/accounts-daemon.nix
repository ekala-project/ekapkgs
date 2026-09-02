# AccountsService — DBus service for user account management
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.services.accounts-daemon = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable AccountsService, a DBus service for accessing
        the list of user accounts and information attached to those accounts.
      '';
    };
  };

  config = mkIf config.services.accounts-daemon.enable {
    environment.systemPackages = [ pkgs.accountsservice ];

    environment.pathsToLink = [ "/share/accountsservice" ];

    services.dbus.packages = [ pkgs.accountsservice ];

    systemd.packages = [ pkgs.accountsservice ];

    systemd.services.accounts-daemon = {
      wantedBy = [ "graphical.target" ];
      environment.XDG_DATA_DIRS = "${config.system.path}/share";
    };
  };
}
