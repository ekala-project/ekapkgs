# System-wide cargo-depgraph configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-depgraph;
in

{
  options.programs.cargo-depgraph = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-depgraph system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-depgraph;
      description = "cargo-depgraph package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
