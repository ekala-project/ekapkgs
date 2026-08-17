# System-wide asciinema-agg configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asciinema-agg;
in

{
  options.programs.asciinema-agg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asciinema-agg system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asciinema-agg;
      description = "asciinema-agg package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
