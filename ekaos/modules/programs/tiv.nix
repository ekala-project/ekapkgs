# System-wide tiv configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tiv;
in

{
  options.programs.tiv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tiv system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tiv;
      description = "tiv package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
