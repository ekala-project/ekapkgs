# System-wide difftastic configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.difftastic;
in

{
  options.programs.difftastic = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install difftastic system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.difftastic;
      description = "difftastic package to use.";
    };

    background = mkOption {
      type = types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = "Terminal background color, sets the DFT_BACKGROUND environment variable.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.DFT_BACKGROUND = cfg.background;
  };
}
