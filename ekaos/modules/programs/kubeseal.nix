# System-wide kubeseal configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.kubeseal;
in

{
  options.programs.kubeseal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install kubeseal system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.kubeseal;
      description = "kubeseal package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
