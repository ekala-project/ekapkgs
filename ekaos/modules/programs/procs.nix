# System-wide procs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.procs;
in

{
  options.programs.procs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install procs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.procs;
      description = "procs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
