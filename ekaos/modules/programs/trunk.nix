# System-wide trunk configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.trunk;
in

{
  options.programs.trunk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install trunk system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.trunk;
      description = "trunk package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
