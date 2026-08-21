# System-wide podman-compose configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.podman-compose;
in

{
  options.programs.podman-compose = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install podman-compose system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.podman-compose;
      description = "podman-compose package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
