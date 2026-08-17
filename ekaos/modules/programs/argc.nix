# System-wide argc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.argc;
in

{
  options.programs.argc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install argc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.argc;
      description = "argc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
