# System-wide amneziawg-go configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.amneziawg-go;
in

{
  options.programs.amneziawg-go = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install amneziawg-go system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.amneziawg-go;
      description = "amneziawg-go package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
