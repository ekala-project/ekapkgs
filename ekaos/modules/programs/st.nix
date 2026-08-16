# System-wide st configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.st;
in

{
  options.programs.st = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install st system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.st;
      description = "st package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
