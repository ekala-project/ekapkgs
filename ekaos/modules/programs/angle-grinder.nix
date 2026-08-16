# System-wide angle-grinder configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.angle-grinder;
in

{
  options.programs.angle-grinder = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install angle-grinder system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.angle-grinder;
      description = "angle-grinder package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
