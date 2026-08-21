# System-wide Consul configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.consul;
in

{
  options.programs.consul = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install consul system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.consul;
      description = "consul package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
