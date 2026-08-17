# System-wide daktilo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.daktilo;
in

{
  options.programs.daktilo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install daktilo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.daktilo;
      description = "daktilo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
