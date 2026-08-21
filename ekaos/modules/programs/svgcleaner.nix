# System-wide svgcleaner configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.svgcleaner;
in

{
  options.programs.svgcleaner = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install svgcleaner system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.svgcleaner;
      description = "svgcleaner package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
