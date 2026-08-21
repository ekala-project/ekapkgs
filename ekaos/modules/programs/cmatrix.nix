# System-wide cmatrix configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cmatrix;
in

{
  options.programs.cmatrix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cmatrix system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cmatrix;
      description = "cmatrix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
