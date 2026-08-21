# System-wide dprint configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dprint;
in

{
  options.programs.dprint = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dprint system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dprint;
      description = "dprint package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
