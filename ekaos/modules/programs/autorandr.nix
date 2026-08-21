# System-wide autorandr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autorandr;
in

{
  options.programs.autorandr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autorandr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autorandr;
      description = "autorandr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
