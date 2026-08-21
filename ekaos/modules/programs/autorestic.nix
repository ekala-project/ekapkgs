# System-wide autorestic configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.autorestic;
in

{
  options.programs.autorestic = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install autorestic system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.autorestic;
      description = "autorestic package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
