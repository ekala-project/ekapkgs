# System-wide genact configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.genact;
in

{
  options.programs.genact = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install genact system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.genact;
      description = "genact package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
