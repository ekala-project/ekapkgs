# System-wide ario configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ario;
in

{
  options.programs.ario = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ario system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ario;
      description = "ario package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
