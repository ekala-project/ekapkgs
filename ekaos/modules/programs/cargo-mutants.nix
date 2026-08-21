# System-wide cargo-mutants configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-mutants;
in

{
  options.programs.cargo-mutants = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-mutants system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-mutants;
      description = "cargo-mutants package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
