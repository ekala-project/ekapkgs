# System-wide bcal configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bcal;
in

{
  options.programs.bcal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bcal system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bcal;
      description = "bcal package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
