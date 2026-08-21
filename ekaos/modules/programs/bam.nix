# System-wide bam configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bam;
in

{
  options.programs.bam = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bam system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bam;
      description = "bam package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
