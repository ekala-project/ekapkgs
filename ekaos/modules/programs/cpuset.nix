# System-wide cpuset configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cpuset;
in

{
  options.programs.cpuset = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cpuset system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cpuset;
      description = "cpuset package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
