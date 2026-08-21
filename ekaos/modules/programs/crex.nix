# System-wide crex configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.crex;
in

{
  options.programs.crex = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install crex system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.crex;
      description = "crex package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
