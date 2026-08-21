# System-wide bartib configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bartib;
in

{
  options.programs.bartib = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bartib system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bartib;
      description = "bartib package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
