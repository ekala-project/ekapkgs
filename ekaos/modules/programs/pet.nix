# System-wide pet configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pet;
in

{
  options.programs.pet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pet system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pet;
      description = "pet package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
