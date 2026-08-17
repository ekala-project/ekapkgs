# System-wide ed configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ed;
in

{
  options.programs.ed = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ed system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ed;
      description = "ed package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
