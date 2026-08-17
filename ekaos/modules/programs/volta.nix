# System-wide volta configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.volta;
in

{
  options.programs.volta = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install volta system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.volta;
      description = "volta package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
