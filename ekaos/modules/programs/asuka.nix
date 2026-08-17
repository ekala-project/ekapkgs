# System-wide asuka configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asuka;
in

{
  options.programs.asuka = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asuka system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asuka;
      description = "asuka package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
