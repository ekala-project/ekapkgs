# System-wide asleap configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asleap;
in

{
  options.programs.asleap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asleap system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asleap;
      description = "asleap package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
