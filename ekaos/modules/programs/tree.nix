# System-wide tree configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tree;
in

{
  options.programs.tree = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tree system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tree;
      description = "tree package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
