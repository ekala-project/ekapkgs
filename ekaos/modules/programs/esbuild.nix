# System-wide esbuild configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.esbuild;
in

{
  options.programs.esbuild = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install esbuild system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.esbuild;
      description = "esbuild package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
