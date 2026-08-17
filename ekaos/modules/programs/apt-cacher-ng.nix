# System-wide apt-cacher-ng configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apt-cacher-ng;
in

{
  options.programs.apt-cacher-ng = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apt-cacher-ng system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apt-cacher-ng;
      description = "apt-cacher-ng package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
