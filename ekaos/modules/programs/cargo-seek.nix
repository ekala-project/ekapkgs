# System-wide cargo-seek configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-seek;
in

{
  options.programs.cargo-seek = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-seek system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-seek;
      description = "cargo-seek package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
