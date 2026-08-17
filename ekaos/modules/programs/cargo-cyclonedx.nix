# System-wide cargo-cyclonedx configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-cyclonedx;
in

{
  options.programs.cargo-cyclonedx = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-cyclonedx system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-cyclonedx;
      description = "cargo-cyclonedx package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
