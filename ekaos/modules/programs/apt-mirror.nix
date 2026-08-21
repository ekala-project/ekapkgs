# System-wide apt-mirror configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apt-mirror;
in

{
  options.programs.apt-mirror = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apt-mirror system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apt-mirror;
      description = "apt-mirror package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
