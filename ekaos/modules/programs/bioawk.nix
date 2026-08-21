# System-wide bioawk configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bioawk;
in

{
  options.programs.bioawk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bioawk system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bioawk;
      description = "bioawk package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
