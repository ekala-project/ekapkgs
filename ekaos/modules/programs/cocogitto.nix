# System-wide cocogitto configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cocogitto;
in

{
  options.programs.cocogitto = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cocogitto system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cocogitto;
      description = "cocogitto package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
