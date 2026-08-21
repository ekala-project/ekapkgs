# System-wide basiliskii configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.basiliskii;
in

{
  options.programs.basiliskii = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install basiliskii system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.basiliskii;
      description = "basiliskii package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
