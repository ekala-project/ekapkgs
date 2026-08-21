# System-wide wush configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wush;
in

{
  options.programs.wush = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wush system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wush;
      description = "wush package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
