# System-wide arkade configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.arkade;
in

{
  options.programs.arkade = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install arkade system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.arkade;
      description = "arkade package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
