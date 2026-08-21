# System-wide gnuplot configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gnuplot;
in

{
  options.programs.gnuplot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gnuplot system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gnuplot;
      description = "gnuplot package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
