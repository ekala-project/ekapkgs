# System-wide dumb-init configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dumb-init;
in

{
  options.programs.dumb-init = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dumb-init system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dumb-init;
      description = "dumb-init package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
