# System-wide _3mux configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_3mux";
in

{
  options.programs."_3mux" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _3mux system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._3mux;
      description = "_3mux package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
