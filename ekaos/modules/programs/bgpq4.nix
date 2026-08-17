# System-wide bgpq4 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bgpq4;
in

{
  options.programs.bgpq4 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bgpq4 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bgpq4;
      description = "bgpq4 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
