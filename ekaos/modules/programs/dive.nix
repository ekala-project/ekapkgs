# System-wide dive configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dive;
in

{
  options.programs.dive = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dive system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dive;
      description = "dive package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
