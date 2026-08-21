# System-wide barrage configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.barrage;
in

{
  options.programs.barrage = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install barrage system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.barrage;
      description = "barrage package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
