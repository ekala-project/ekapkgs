# System-wide aribb25 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aribb25;
in

{
  options.programs.aribb25 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aribb25 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aribb25;
      description = "aribb25 package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
