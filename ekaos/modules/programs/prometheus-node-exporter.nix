# System-wide prometheus-node-exporter configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.prometheus-node-exporter;
in

{
  options.programs.prometheus-node-exporter = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install prometheus-node-exporter system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.prometheus-node-exporter;
      description = "prometheus-node-exporter package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
