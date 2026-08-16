# System-wide toilet configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.toilet;
in

{
  options.programs.toilet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install toilet system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.toilet;
      description = "toilet package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
