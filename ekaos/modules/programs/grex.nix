# System-wide grex configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.grex;
in

{
  options.programs.grex = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install grex system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.grex;
      description = "grex package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
