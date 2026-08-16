# System-wide dool configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dool;
in

{
  options.programs.dool = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dool system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dool;
      description = "dool package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
