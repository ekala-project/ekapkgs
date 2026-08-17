# System-wide sad configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sad;
in

{
  options.programs.sad = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sad system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sad;
      description = "sad package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
