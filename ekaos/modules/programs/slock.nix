# System-wide slock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.slock;
in

{
  options.programs.slock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable slock screen locker.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.slock;
      description = "slock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.slock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${cfg.package}/bin/slock";
    };
  };
}
