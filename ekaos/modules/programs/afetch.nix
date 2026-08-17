# System-wide afetch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.afetch;
in

{
  options.programs.afetch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install afetch system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.afetch;
      description = "afetch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
