# System-wide beanstalkd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.beanstalkd;
in

{
  options.programs.beanstalkd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install beanstalkd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.beanstalkd;
      description = "beanstalkd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
