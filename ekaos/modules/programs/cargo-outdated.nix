# System-wide cargo-outdated configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-outdated;
in

{
  options.programs.cargo-outdated = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-outdated system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-outdated;
      description = "cargo-outdated package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
