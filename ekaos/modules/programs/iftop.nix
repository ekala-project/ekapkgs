# System-wide iftop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.iftop;
in

{
  options.programs.iftop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install iftop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.iftop;
      description = "iftop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
