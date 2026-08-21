# System-wide mtr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mtr;
in

{
  options.programs.mtr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mtr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mtr;
      description = "mtr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
