# System-wide babl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.babl;
in

{
  options.programs.babl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install babl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.babl;
      description = "babl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
