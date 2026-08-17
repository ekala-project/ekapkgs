# System-wide andi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.andi;
in

{
  options.programs.andi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install andi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.andi;
      description = "andi package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
