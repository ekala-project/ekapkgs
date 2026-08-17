# System-wide cargo-hack configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-hack;
in

{
  options.programs.cargo-hack = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-hack system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-hack;
      description = "cargo-hack package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
