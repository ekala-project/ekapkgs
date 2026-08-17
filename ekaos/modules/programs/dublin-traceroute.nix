# System-wide dublin-traceroute configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dublin-traceroute;
in

{
  options.programs.dublin-traceroute = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable dublin-traceroute with cap_net_raw capability.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dublin-traceroute;
      description = "dublin-traceroute package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.dublin-traceroute = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = "${cfg.package}/bin/dublin-traceroute";
    };
  };
}
