# System-wide atomicparsley configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atomicparsley;
in

{
  options.programs.atomicparsley = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atomicparsley system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atomicparsley;
      description = "atomicparsley package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
