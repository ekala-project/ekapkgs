# System-wide iperf3 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.iperf3;
in

{
  options.programs.iperf3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install iperf3 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.iperf3;
      description = "iperf3 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
