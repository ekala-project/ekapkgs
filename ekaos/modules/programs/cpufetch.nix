# System-wide cpufetch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cpufetch;
in

{
  options.programs.cpufetch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cpufetch system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cpufetch;
      description = "cpufetch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
