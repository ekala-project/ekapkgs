# System-wide jdupes configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.jdupes;
in

{
  options.programs.jdupes = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install jdupes system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.jdupes;
      description = "jdupes package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
