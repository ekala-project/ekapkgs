# System-wide cargo-sort configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-sort;
in

{
  options.programs.cargo-sort = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-sort system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-sort;
      description = "cargo-sort package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
