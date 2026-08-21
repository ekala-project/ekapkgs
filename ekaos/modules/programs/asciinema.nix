# System-wide asciinema configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asciinema;
in

{
  options.programs.asciinema = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asciinema system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asciinema;
      description = "asciinema package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
