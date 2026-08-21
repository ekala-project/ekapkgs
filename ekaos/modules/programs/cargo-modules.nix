# System-wide cargo-modules configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-modules;
in

{
  options.programs.cargo-modules = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-modules system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-modules;
      description = "cargo-modules package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
