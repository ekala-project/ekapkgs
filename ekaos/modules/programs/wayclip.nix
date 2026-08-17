# System-wide wayclip configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wayclip;
in

{
  options.programs.wayclip = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wayclip system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wayclip;
      description = "wayclip package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
