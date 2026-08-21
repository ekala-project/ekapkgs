# System-wide lxterminal configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lxterminal;
in

{
  options.programs.lxterminal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lxterminal system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lxterminal;
      description = "lxterminal package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
