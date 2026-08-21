# System-wide cargo-bloat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-bloat;
in

{
  options.programs.cargo-bloat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-bloat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-bloat;
      description = "cargo-bloat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
