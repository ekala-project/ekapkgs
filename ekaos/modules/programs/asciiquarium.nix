# System-wide asciiquarium configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asciiquarium;
in

{
  options.programs.asciiquarium = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asciiquarium system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asciiquarium;
      description = "asciiquarium package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
