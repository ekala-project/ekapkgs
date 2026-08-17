# System-wide bed configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bed;
in

{
  options.programs.bed = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bed system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bed;
      description = "bed package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
