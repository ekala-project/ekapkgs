# System-wide bdftopcf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bdftopcf;
in

{
  options.programs.bdftopcf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bdftopcf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bdftopcf;
      description = "bdftopcf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
