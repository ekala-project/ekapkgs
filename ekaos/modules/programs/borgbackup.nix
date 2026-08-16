# System-wide BorgBackup configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.borgbackup;
in

{
  options.programs.borgbackup = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install BorgBackup system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.borgbackup;
      description = "BorgBackup package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
