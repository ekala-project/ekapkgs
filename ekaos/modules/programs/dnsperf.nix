# System-wide dnsperf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dnsperf;
in

{
  options.programs.dnsperf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dnsperf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dnsperf;
      description = "dnsperf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
