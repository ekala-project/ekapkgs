# System-wide docker-compose configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.docker-compose;
in

{
  options.programs.docker-compose = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install docker-compose system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.docker-compose;
      description = "docker-compose package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
