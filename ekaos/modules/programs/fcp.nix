# System-wide fcp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fcp;
in

{
  options.programs.fcp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fcp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fcp;
      description = "fcp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
