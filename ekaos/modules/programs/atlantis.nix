# System-wide atlantis configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.atlantis;
in

{
  options.programs.atlantis = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install atlantis system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.atlantis;
      description = "atlantis package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
