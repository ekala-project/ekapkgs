# System-wide xq-xml configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xq-xml;
in

{
  options.programs.xq-xml = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xq-xml system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xq-xml;
      description = "xq-xml package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
