# System-wide optipng configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.optipng;
in

{
  options.programs.optipng = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install optipng system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.optipng;
      description = "optipng package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
