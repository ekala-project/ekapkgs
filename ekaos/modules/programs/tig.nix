# System-wide tig configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tig;
in

{
  options.programs.tig = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tig system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tig;
      description = "tig package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
