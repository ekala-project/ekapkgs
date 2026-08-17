# System-wide basu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.basu;
in

{
  options.programs.basu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install basu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.basu;
      description = "basu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
