# System-wide fyi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fyi;
in

{
  options.programs.fyi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fyi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fyi;
      description = "fyi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
