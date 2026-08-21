# System-wide below configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.below;
in

{
  options.programs.below = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install below system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.below;
      description = "below package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
