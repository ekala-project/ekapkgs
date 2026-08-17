# System-wide agate configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.agate;
in

{
  options.programs.agate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install agate system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.agate;
      description = "agate package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
