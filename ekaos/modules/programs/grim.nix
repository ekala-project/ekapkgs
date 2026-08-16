# System-wide grim configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.grim;
in

{
  options.programs.grim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install grim system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.grim;
      description = "grim package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
