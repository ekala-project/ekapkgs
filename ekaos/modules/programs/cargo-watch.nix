# System-wide cargo-watch configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-watch;
in

{
  options.programs.cargo-watch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-watch system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-watch;
      description = "cargo-watch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
