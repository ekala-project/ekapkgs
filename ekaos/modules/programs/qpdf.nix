# System-wide qpdf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.qpdf;
in

{
  options.programs.qpdf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install qpdf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qpdf;
      description = "qpdf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
