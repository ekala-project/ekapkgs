# System-wide flashrom configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.flashrom;
in

{
  options.programs.flashrom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install flashrom system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.flashrom;
      description = "flashrom package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
