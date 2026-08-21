# System-wide pdfcpu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pdfcpu;
in

{
  options.programs.pdfcpu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pdfcpu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pdfcpu;
      description = "pdfcpu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
