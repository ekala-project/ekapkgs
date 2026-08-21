# System-wide byobu configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.byobu;
in

{
  options.programs.byobu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install byobu system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.byobu;
      description = "byobu package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
