# System-wide cargo-audit configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-audit;
in

{
  options.programs.cargo-audit = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-audit system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-audit;
      description = "cargo-audit package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
