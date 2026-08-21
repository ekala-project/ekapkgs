# System-wide apt-swarm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apt-swarm;
in

{
  options.programs.apt-swarm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apt-swarm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apt-swarm;
      description = "apt-swarm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
