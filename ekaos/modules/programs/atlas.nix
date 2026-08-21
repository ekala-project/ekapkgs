# System-wide atlas configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atlas;
in

{
  options.programs.atlas = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atlas system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atlas;
      description = "atlas package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
