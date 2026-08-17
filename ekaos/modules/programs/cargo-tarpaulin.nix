# System-wide cargo-tarpaulin configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-tarpaulin;
in

{
  options.programs.cargo-tarpaulin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-tarpaulin system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-tarpaulin;
      description = "cargo-tarpaulin package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
