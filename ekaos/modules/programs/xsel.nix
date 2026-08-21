# System-wide xsel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xsel;
in

{
  options.programs.xsel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xsel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xsel;
      description = "xsel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
