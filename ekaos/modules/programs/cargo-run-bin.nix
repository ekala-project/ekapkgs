# System-wide cargo-run-bin configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-run-bin;
in

{
  options.programs.cargo-run-bin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-run-bin system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-run-bin;
      description = "cargo-run-bin package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
