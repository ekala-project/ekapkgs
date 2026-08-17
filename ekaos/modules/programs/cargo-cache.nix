# System-wide cargo-cache configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-cache;
in

{
  options.programs.cargo-cache = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-cache system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-cache;
      description = "cargo-cache package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
