# System-wide topiary configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.topiary;
in

{
  options.programs.topiary = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install topiary system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.topiary;
      description = "topiary package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
