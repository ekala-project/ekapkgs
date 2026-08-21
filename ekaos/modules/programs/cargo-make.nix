# System-wide cargo-make configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-make;
in

{
  options.programs.cargo-make = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-make system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-make;
      description = "cargo-make package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
