# System-wide aldo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aldo;
in

{
  options.programs.aldo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aldo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aldo;
      description = "aldo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
