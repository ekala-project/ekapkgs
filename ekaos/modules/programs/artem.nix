# System-wide artem configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.artem;
in

{
  options.programs.artem = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install artem system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.artem;
      description = "artem package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
