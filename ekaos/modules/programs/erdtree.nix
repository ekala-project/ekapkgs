# System-wide erdtree configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.erdtree;
in

{
  options.programs.erdtree = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install erdtree system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.erdtree;
      description = "erdtree package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
