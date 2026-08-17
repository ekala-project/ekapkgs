# System-wide add-determinism configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.add-determinism;
in

{
  options.programs.add-determinism = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install add-determinism system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.add-determinism;
      description = "add-determinism package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
