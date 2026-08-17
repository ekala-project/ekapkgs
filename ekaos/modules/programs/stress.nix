# System-wide stress configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stress;
in

{
  options.programs.stress = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stress system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stress;
      description = "stress package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
