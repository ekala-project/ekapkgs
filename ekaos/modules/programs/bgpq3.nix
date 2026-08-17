# System-wide bgpq3 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bgpq3;
in

{
  options.programs.bgpq3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bgpq3 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bgpq3;
      description = "bgpq3 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
