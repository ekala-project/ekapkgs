# System-wide dmenu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dmenu;
in

{
  options.programs.dmenu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dmenu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dmenu;
      description = "dmenu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
