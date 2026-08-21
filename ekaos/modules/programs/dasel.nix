# System-wide dasel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dasel;
in

{
  options.programs.dasel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dasel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dasel;
      description = "dasel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
