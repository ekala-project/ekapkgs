# System-wide aucatctl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aucatctl;
in

{
  options.programs.aucatctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aucatctl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aucatctl;
      description = "aucatctl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
