# System-wide thermald configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.thermald;
in

{
  options.programs.thermald = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install thermald system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.thermald;
      description = "thermald package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
