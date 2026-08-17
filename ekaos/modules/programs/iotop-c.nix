# System-wide iotop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.iotop;
in

{
  options.programs.iotop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable iotop with cap_net_admin capability.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.iotop-c;
      description = "iotop package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.iotop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = "${cfg.package}/bin/iotop-c";
    };
  };
}
