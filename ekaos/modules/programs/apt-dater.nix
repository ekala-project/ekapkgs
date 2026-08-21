# System-wide apt-dater configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apt-dater;
in

{
  options.programs.apt-dater = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apt-dater system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apt-dater;
      description = "apt-dater package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
