# System-wide fdupes configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.fdupes;
in

{
  options.programs.fdupes = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install fdupes system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.fdupes;
      description = "fdupes package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
