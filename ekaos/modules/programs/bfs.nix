# System-wide bfs configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bfs;
in

{
  options.programs.bfs = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bfs system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bfs;
      description = "bfs package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
