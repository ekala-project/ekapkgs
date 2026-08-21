# System-wide cronie configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cronie;
in

{
  options.programs.cronie = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cronie system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cronie;
      description = "cronie package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
